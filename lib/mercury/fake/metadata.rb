class Mercury
  class Fake
    class Metadata
      def initialize(tag, dequeue, requeue)
        @tag = tag
        @dequeue = dequeue
        @requeue = requeue
      end

      def routing_key
        @tag
      end

      def ack
        @dequeue.call
      end

      def reject(opts)
        requeue = opts[:requeue]
        requeue ? @requeue.call : @dequeue.call
      end
    end
  end
end
