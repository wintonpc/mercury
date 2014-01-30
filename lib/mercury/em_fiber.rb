require 'eventmachine'
require 'fiber'

module EventMachine
  class << self
    def run_in_fiber(&block)
      run do
        Fiber.new(&block).resume
      end
    end
  end
end

module EMFiber

  def block(&cps)
    f = Fiber.current
    cps.call(proc{f.resume})
    Fiber.yield
  end

  extend self
end
