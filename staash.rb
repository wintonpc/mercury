require_relative 'lib/messaging'
require 'eventmachine'
require 'ap'

module Handler
  def post_init
    @pipe = MsgPipe.new(&method(:receive_msg))
  end

  def receive_data(bytes)
    pipe.write(bytes)
  end

  def receive_msg(msg)
  end

  def unbind

  end
end

EM.run do
  EM.start_server '0.0.0.0', 7890, Handler
end
