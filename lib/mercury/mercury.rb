require 'amqp'
require 'securerandom'
require 'messaging'
require 'eventmachine'
require 'mercury/deferrable'

class Mercury
  include Deferrable

  attr_accessor :amqp, :channel

  def initialize
    AMQP.connect(:host => 'localhost') do |amqp|
      @amqp = amqp
      @channel = AMQP::Channel.new(amqp, prefetch: 1) do
        @default_exchange = @channel.direct('')
        do_deferred
      end
    end
  end

  def new_singleton(name = nil, &rcv)
    s = MercurySingleton.new(self, name, &rcv)
    do_or_defer {s.connect}
    s
  end

  def send_to(name, msg)
    do_or_defer {
      @default_exchange.publish(write(msg), routing_key: name)
    }
  end

  def publish(source_name, msg, &block)
    do_or_defer {
      with_source(source_name) do |exchange|
        exchange.publish(write(msg), delivery_mode: 2, &block)
      end
    }
  end

  def start_worker(worker_group, source_name, &rcv)
    do_or_defer {
      with_source(source_name) do |exchange|
        with_work_queue(worker_group, exchange) do |queue|
          queue.subscribe(ack: true) do |metadata, payload|
            rcv.(WireSerializer.read(payload), ->{ metadata.ack })
          end
        end
      end
    }
  end

  def start_listener(source_name, &rcv)
    do_or_defer {
      with_source(source_name) do |exchange|
        queue = @channel.queue('', exclusive: true, auto_delete: true, durable: false)
        queue.bind(exchange) do
          queue.subscribe(ack: false) do |_, payload|
            rcv.(WireSerializer.read(payload))
          end
        end
      end
    }
  end

  private

  def write(msg)
    ENV['DEBUG'] ? WireSerializer.write_json(msg) : WireSerializer.write(msg)
  end

  def with_source(source_name)
    @source_exchanges ||= {}
    exchange = @source_exchanges[source_name]
    if exchange
      yield exchange
    else
      @channel.fanout(source_name, durable: true, auto_delete: false) do |exchange|
        @source_exchanges[source_name] = exchange
        yield exchange
      end
    end
  end

  def with_work_queue(worker_group, source_exchange)
    queue = @channel.queue(worker_group, durable: true, auto_delete: false)
    queue.bind(source_exchange) do
      yield queue
    end
  end

end

class MercurySingleton
  attr_accessor :name

  def initialize(mercury, name, &rcv)
    @mercury = mercury
    @name = name || "mercury-singleton-#{SecureRandom.uuid.gsub('-', '')[0...12]}"
    @rcv = rcv
  end

  def connect
    @queue = @mercury.channel.queue(@name, exclusive: true, auto_delete: true, durable: false) do |queue|
      break if @closed
      queue.subscribe do |payload|
        break if @closed
        msg = WireSerializer.read(payload)
        if @response_handler
          handler = @response_handler
          @response_handler = nil
          handler.call(msg)
        elsif @rcv
          @rcv.(msg)
        end
      end
    end
  end

  def send_to(*args)
    throw 'was previously closed' if @closed
    @mercury.send_to(*args)
  end

  def request(dest_name, request, &response_handler)
    throw 'was previously closed' if @closed
    send_to(dest_name, request)
    @response_handler = response_handler
  end

  def close
    return if @closed
    @closed = true
    @queue and @queue.delete(nowait: true)
  end
end