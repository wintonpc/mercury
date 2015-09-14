class Cps

  # Syntactic sugar for and_then chains.
  def self.seq(&block)
    s = Seq.new
    block.call(s.method(:chain))
    s.m
  end

  # # Syntactic sugar for and_then chains.
  # def self.seqp(&block)
  #   proc do |*args|
  #     s = Seq.new
  #     block.call(s.method(:chain), *args)
  #     s.m
  #   end
  # end

  class Seq
    def m
      @m ||= Cps.identity # we need an initial Cps to chain onto
    end

    def chain(proc=nil, &block)
      @m = m.and_then(&(proc || block))
    end
  end
end

class Method
  alias_method :en, :call # to be called `th.en`
end
