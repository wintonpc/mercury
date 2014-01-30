require 'mercury/mercury'
require 'mercury/em_fiber'

class Mercury
  class Sync
    include EMFiber

    def self.open(**kws)
      EMFiber.block do |unblock|
        Mercury.open(**kws) do |m|
          unblock.call(new(m))
        end
      end
    end

    private
    def initialize(mercury)
      @mercury = mercury
    end
  end
end
