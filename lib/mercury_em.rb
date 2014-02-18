require_relative 'messaging'
require 'message_pipe'
require 'eventmachine'

class Mercury
  module EM

    def self.start_message_server(port, &block)
      ::EM.start_server '0.0.0.0', port, make_server_handler(&block)
    end

    private

    def self.make_server_handler(&block)
      Module.new do
        def post_init
          @pipe = MessagePipe.new(&method(:receive_msg))
        end

        def receive_data(bytes)
          @pipe.write(bytes)
        end

        define_method :receive_msg do |msg|
          block.(msg, ->(m){send_data(MessagePipe.message_to_bytes(m))})
        end

        def unbind

        end
      end
    end

  end
end