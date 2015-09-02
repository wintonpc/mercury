class Mercury
  class Fake
    class Metadata
      def initialize(tag, &dequeue)
        @tag = tag
        @dequeue = dequeue
      end

      def routing_key
        @tag
      end

      def ack
        @dequeue.call
      end

      def reject(*_args)
        @dequeue.call
      end
    end
  end
end
