require 'rspec'
require 'mercury/test_utils'
include Mercury::TestUtils

# the block must return a Cps
def test_with_mercury_cps(sources, queues, &block)
  em do
    seql do
      let(:m)  { Mercury::Monadic.open }
      and_then { delete_sources_and_queues_cps(sources, queues) }
      and_then { block.call(m) }
      and_then { delete_sources_and_queues_cps(sources, queues) }
      and_then { m.close }
      and_lift { done }
    end.run
  end
end
