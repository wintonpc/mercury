class Mercury
  class Fake
    class Subscriber
      attr_reader :handler
      attr_accessor :busy

      def initialize(handler)
        @handler = handler
        @busy = false
      end
    end
  end
end
