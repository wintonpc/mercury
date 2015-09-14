require 'spec_helper'
require 'mercury'

describe Mercury do
  include MercuryFakeSpec

  # These tests just cover the basics. Most of the testing is
  # done in the Mercury::Monadic spec for convenience.

  let!(:sent) { { 'a' => 1 } }
  let!(:source) { 'test-exchange' }
  let!(:queue) { 'test-queue' }

  describe '::open' do
    it 'opens a mercury instance' do
      em do
        Mercury.open do |m|
          expect(m).to be_a Mercury
          m.close do
            done
          end
        end
      end
    end
  end

  describe '#close' do
    itt 'closes the connection' do
      em do
        Mercury.open do |m|
          m.close do
            expect { m.publish(queue, {'a' => 1}) }.to raise_error /connection is closed/
            done
          end
        end
      end
    end
  end

  describe '#start_listener' do
    itt 'listens for messages' do
      with_mercury do |m|
        received = []
        m.start_listener(source, received.method(:push)) do
          m.publish(source, sent) do
            em_wait_until(proc{received.any?}) do
              expect(received.size).to eql 1
              expect(received[0].content).to eql sent
              m.close do
                done
              end
            end
          end
        end
      end
    end
  end

  describe '#start_worker' do
    itt 'listens for messages' do
      with_mercury do |m|
        received = []
        m.start_worker(queue, source, received.method(:push)) do
          m.publish(source, sent) do
            em_wait_until(proc{received.any?}) do
              expect(received.size).to eql 1
              expect(received[0].content).to eql sent
              m.close do
                done
              end
            end
          end
        end
      end
    end
  end

  def with_mercury(&block)
    sources = [source]
    queues = [queue]
    em { delete_sources_and_queues_cps(sources, queues).run{done} }
    em { Mercury.open(&block) }
    em { delete_sources_and_queues_cps(sources, queues).run{done} }
  end

end

