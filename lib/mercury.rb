require 'amqp'
require 'securerandom'
require 'wire_serializer'
require 'eventmachine'

module Deferrable

  def do_or_defer(&work)
    @deferred ||= []
    @deferred_initialized ? work.() : @deferred.push(work)
  end

  def do_deferred
    @deferred ||= []
    @deferred_initialized = true
    @deferred.each(&:call)
  end
end

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

  def new_singleton(name = nil, &rcv)
    s = MercurySingleton.new(self, name, &rcv)
    do_or_defer {s.connect}
    s
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

  def self.request(dest_name, make_req, &handle_response)
    EM.run do
      mercury = Mercury.new
      ms = mercury.new_singleton do |msg|
        handle_response && handle_response.(msg)
        EM.stop
      end

      mercury.send_to(dest_name, make_req.respond_to?(:call) ? make_req.(ms.name) : make_req)
    end
  end

  def write(msg)
    ENV['DEBUG'] ? WireSerializer.write_json(msg) : WireSerializer.write(msg)
  end
end

class MercurySingleton
  include Deferrable

  attr_accessor :name

  def initialize(mercury, name, &rcv)
    @mercury = mercury
    @name = name || "mercury-singleton-#{SecureRandom.uuid}"
    @rcv = rcv
  end

  def connect
    @queue = @mercury.channel.queue(@name, exclusive: true, auto_delete: true, durable: false) do |queue|
      if @rcv
        queue.subscribe do |payload|
          @rcv.(WireSerializer.read(payload))
        end
      end
      do_deferred
    end
  end

  def send_to(*args)
    @mercury.send_to(*args)
  end

  def close
    @queue and @queue.delete(nowait: true)
  end
end