require 'eventmachine'
require 'mercury/cps'
require 'mercury/monadic'

class Mercury
  module TestUtils
    def em
      EM.run do
        EM.add_timer(in_debug_mode? ? 999999 : 3) { raise 'EM spec timed out' }
        yield
      end
    end

    def in_debug_mode?
      ENV['RUBYLIB'] =~ /ruby-debug-ide/ # http://stackoverflow.com/questions/22039807/determine-if-a-program-is-running-in-debug-mode
    end

    def done
      EM.stop
    end

    def em_wait_until(pred, &k)
      try_again = proc do
        if pred.call
          k.call
        else
          EM.add_timer(1.0 / 50, try_again)
        end
      end
      try_again.call
    end

    def wait_until(&pred)
      cps do |&k|
        em_wait_until(pred, &k)
      end
    end

    def wait_for(seconds)
      cps do |&k|
        EM.add_timer(seconds, &k)
      end
    end

    def delete_sources_and_queues_cps(source_names, queue_names)
      # We must create a new mercury. The AMQP gem doesn't let you redeclare
      # a construct with the same instance you deleted it with.
      Mercury::Monadic.open.and_then do |m|
        Cps.inject(amq_filter(source_names)) { |s| m.delete_source(s) }.
          inject(amq_filter(queue_names)) { |q| m.delete_work_queue(q) }.
          and_then { m.close }
      end
    end

    def amq_filter(xs)
      xs.reject{|x| x.start_with?('amq.')}
    end
  end
end
