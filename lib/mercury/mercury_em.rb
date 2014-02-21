require 'messaging'
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
          #puts "Client connected: #{peer_name}"
          @pipe = MessagePipe.new(&method(:receive_msg))
        end

        def receive_data(bytes)
          @pipe.write(bytes)
        end

        define_method :receive_msg do |msg|
          block.(msg, ->(m){send_data(MessagePipe.message_to_bytes(m))})
        end

        def unbind
          #puts "Client disconnected: #{peer_name}"
        end

        private

        def peer_name
          @peer_name ||= get_peer_name
        end

        def get_peer_name
          port, *octets = get_peername[2,6].unpack('nC4')
          "#{octets.join('.')}:#{port}"
        end
      end
    end

  end
end