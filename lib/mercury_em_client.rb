require_relative 'messaging'
require 'eventmachine'

class MercuryEMClient

  def initialize(addr, port, &on_receive)
    @conn = EM.connect(addr, port, EMClient)
    @conn.on_receive(&method(:handle_msg))
    @on_receive = on_receive
  end

  def send_message(msg)
    @conn.send_message(msg)
  end

  def send_request(msg, &on_response)
    @on_response = on_response
    @conn.send_message(msg)
  end

  def on_receive(&on_receive)
    @on_receive = on_receive
  end

  private

  def handle_msg(msg)
    if @on_response
      on_response = @on_response
      @on_response = nil # must nil it out before calling handler in case handler calls send_request
      on_response.(msg)
    elsif @on_receive
      @on_receive.(msg)
    else
      puts 'Dropping a message because no handlers are hooked.'
    end
  end

  class EMClient < EM::Connection
    def post_init
      @handle_msg = Proc.new {}
      @pipe = MessagePipe.new {|msg| @handle_msg.(msg) }
    end

    def send_message(msg)
      send_data(MessagePipe.message_to_bytes(msg))
    end

    def on_receive(&block)
      @handle_msg = block
    end

    #private

    def receive_data(bytes)
      @pipe.write(bytes)
    end
  end

end