require 'spec_helper'
require 'mercury/sync'
require 'mercury/monadic'

describe Mercury::Sync do
  include Cps::Methods
  let!(:source) { 'test-exchange1' }
  let!(:queue) { 'test-queue1' }
  describe '::publish' do
    it 'publishes synchronously' do
      sent = {'a' => 1}
      received = []
      test_with_mercury do |m|
        seql do
          and_then { m.start_listener(source, received.method(:push)) }
          and_lift { Mercury::Sync.publish(source, sent) }
          and_then { wait_until { received.any? } }
          and_lift do
            expect(received.size).to eql 1
            expect(received[0].content).to eql sent
          end
        end
      end
    end
  end

  # the block must return a Cps
  def test_with_mercury(&block)
    sources = [source]
    queues = [queue]
    test_with_mercury_cps(sources, queues, &block)
  end
end
