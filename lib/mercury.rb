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

  attr_accessor :amqp

  def initialize
    AMQP.connect(:host => 'localhost') do |amqp|
      @amqp = amqp
      do_deferred
    end
  end

  def new_singleton(name = nil, &rcv)
    s = MercurySingleton.new(self, name, &rcv)
    do_or_defer {s.connect}
    s
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
    @channel = AMQP::Channel.new(@mercury.amqp)
    @default_exchange = @channel.direct('')
    @queue = @channel.queue(@name, exclusive: true, auto_delete: true, durable: false)
    @queue.subscribe do |payload|
      @rcv.(WireSerializer.read(payload))
    end
    do_deferred
  end

  def send_to(name, msg)
    serialized_msg = ENV['DEBUG'] ? WireSerializer.write_json(msg) : WireSerializer.write(msg)
    do_or_defer {@default_exchange.publish(serialized_msg, routing_key: name)}
  end
end