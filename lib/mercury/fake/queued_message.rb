require 'mercury/fake/metadata'
require 'mercury/received_message'

class Mercury
  class Fake
    class QueuedMessage
      attr_reader :received_msg
      attr_accessor :delivered, :subscriber

      def initialize(queue, msg, tag, is_ackable)
        metadata = Metadata.new(tag) do
          # ReceivedMessage guarantees this is only called for work queues
          subscriber.busy = false
          queue.ack_or_reject_message(self)
        end
        @received_msg = ReceivedMessage.new(msg, metadata, is_ackable: is_ackable)
        @delivered = false
      end
    end
  end
end
