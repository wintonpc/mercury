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
      @channel = AMQP::Channel.new(amqp) do
        @default_exchange = @channel.direct('')
        do_deferred
      end
    end
  end

  def send_to(name, msg)
    do_or_defer {
      serialized_msg = ENV['DEBUG'] ? WireSerializer.write_json(msg) : WireSerializer.write(msg)
      @default_exchange.publish(serialized_msg, routing_key: name)
    }
  end

  def new_singleton(name = nil, &rcv)
    s = MercurySingleton.new(self, name, &rcv)
    do_or_defer {s.connect}
    s
  end

  def self.request(dest_name, make_req, &handle_response)
    EM.run do
      mercury = Mercury.new
      ms = mercury.new_singleton do |msg|
        handle_response.(msg)
        EM.stop
      end

      mercury.send_to(dest_name, make_req.(ms.name))
      EM.stop unless handle_response
    end
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
end