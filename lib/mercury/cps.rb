require 'mercury/cps/seq'
require 'mercury/cps/seq_with_let'
require 'mercury/cps/methods'

# Async IO often involves CPS (continuation-passing style)
# code, where the continuation (a.k.a. "callback") is passed
# to a function to be invoked at a later time. CPS style
# can result in deep lexical nesting making code difficult
# to read.
# This monad hides the CPS plumbing, which allows code
# to be written in a flat style with no visible continuation
# passing. It basically wraps a CPS proc with methods for
# composing them.
# See http://codon.com/refactoring-ruby-with-monads
class Cps
  attr_reader :cps
  attr_reader :on_err

  # @param [Proc] cps a CPS proc (signature: *args, &k)
  def initialize(&cps)
    @cps = cps
    @on_err = proc {|e| raise e}
  end

  # Applies the wrapped proc. If the CPS return value
  # is not needed, the continuation k may be omitted.
  # Returns the return value of the continuation.
  def run(*args, &k)
    k ||= proc{|x| x}
    cps.call(*args, &k)
  rescue Exception => e
    on_err.call(e, proc{|*args| Cps.new{k.call(*args)}}).run
  end

  # The "bind" operation; composes two Cps
  # @param [Proc] pm a proc that takes the output of this
  #   Cps and returns a Cps
  def and_then(&pm)
    Cps.new do |*args, &k|
      self.run(*args) do |*args2|
        pm.call(*args2).run(&k)
      end
    end
  end

  # equivalent to: and_then { lift { ... } }
  def and_lift(&p)
    and_then do |*args|
      Cps.lift { p.call(*args) }
    end
  end

  # Returns a Cps for a non-CPS proc.
  def self.lift(&p)
    new { |*args, &k| k.call(p.call(*args)) }
  end

  # The identity function as a Cps.
  def self.identity
    new { |*args, &k| k.call(*args) }
  end

  def recover(&pm)
    old_on_err = @on_err
    @on_err = proc do |e, cc|
      begin
        old_on_err.call(e, cc)
      rescue Exception => e2
        pm.call(e2, cc)
      end
    end
    self
  end

  def finally(&cleanup)
    cleaned_up = false
    self.and_then { cleanup.and_then{|*args| cleaned_up = true; lift{args}} }
    recover do |e|
      if cleaned_
      cleanup.and_then { raise e }
    end
  end

  # Returns a Cps that executes the provided Cpses concurrently.
  # Once all complete, their return values are passed to the continuation
  # in an array with positions corresponding to the provided Cpses.
  def self.concurrently(*cpss)
    if cpss.size == 1 && cpss.is_a?(Array) # allow splatted or non-splatted
      cpss = cpss.first
    end

    Cps.new do |*in_args, &k|
      pending_completions = cpss
      returned_args = []
      cpss.each_with_index do |cps, i|
        cps.run(*in_args) do |*out_args|
          returned_args[i] = out_args
          pending_completions.delete(cps)
          if pending_completions.none?
            k.call(returned_args)
          end
        end
      end
    end
  end

  # Calls and_then for each x.
  # @yieldparam  x     [Object]  An item from xs
  # @yieldparam  *args [Objects] The value(s) passed from the last action
  # @yieldreturn       [Cps]     The next action to add to the chain
  def inject(xs, &block)
    xs.inject(self) do |chain, x|
      chain.and_then { |*args| block.call(x, *args) }
    end
  end

  # equivalent to Cps.identity.inject(...)
  def self.inject(xs, &block)
    Cps.identity.inject(xs, &block)
  end
end
