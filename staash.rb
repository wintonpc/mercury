require_relative 'lib/messaging'
require 'eventmachine'
require 'ap'

module Handler
  def post_init
    @pipe = MessagePipe.new(&method(:receive_msg))
  end

  def receive_data(bytes)
    @pipe.write(bytes)
  end

  def receive_msg(msg)
    response = Ib::Mutex::V1::Response.new(request: msg, release_token: 'foo',
                                           was_obtained: false, obtained_abandoned: false)
    send_data(MessagePipe.message_to_bytes(response))
  end

  def unbind

  end
end

EM.run do
  EM.start_server '0.0.0.0', 7890, Handler
  puts 'Listening...'
end
