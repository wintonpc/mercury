require 'eventmachine'
require 'mercury/fake/queued_message'

class Mercury
  class Fake
    class Queue
      attr_reader :source, :worker

      def initialize(source, tag_filter, worker, require_ack)
        @source = source
        @tag_filter = tag_filter
        @worker = worker
        @require_ack = require_ack
        @msgs = []
        @subscribers = []
      end

      def add_subscriber(s)
        subscribers << s
        deliver # new subscriber probably wants a message
      end

      def enqueue(msg, tag)
        msgs.push(QueuedMessage.new(self, msg, tag, @require_ack))
        deliver # new message. someone probably wants it.
      end

      def ack_or_reject_message(msg)
        msgs.delete(msg) or raise 'tried to delete message that was not in queue!!'
        msg.subscriber.busy = false
        deliver # a subscriber just freed up
      end

      def nack(msg)
        msg.delivered = false
        msg.subscriber.busy = false
        deliver
      end

      def binds?(source_name, tag)
        source_name == source && tag_match?(tag_filter, tag)
      end

      private
      attr_reader :msgs, :subscribers, :tag_filter

      def tag_match?(filter, tag)
        # for wildcard description, see https://www.rabbitmq.com/tutorials/tutorial-five-python.html
        pattern = Regexp.new(filter.gsub('*', '[^\.]+').gsub('#', '.*?'))
        pattern.match(tag)
      end

      def deliver
        EM.next_tick do
          if idle_subscribers.any? && undelivered.any?
            msg = undelivered.first
            subscriber = idle_subscribers.sample
            if @require_ack
              msg.delivered = true
              subscriber.busy = true
            else
              msgs.delete(msg)
            end
            msg.subscriber = subscriber
            subscriber.handler.call(msg.received_msg)
            deliver # continue delivering
          end
        end
      end

      def undelivered
        msgs.reject(&:delivered)
      end

      def idle_subscribers
        subscribers.reject(&:busy)
      end
    end
  end
end
