module Deferrable

  def do_or_defer(&work)
    @deferred ||= []
    @deferred_initialized ? work.() : @deferred.push(work)
  end

  def do_deferred
    @deferred ||= []
    @deferred_initialized = true
    @deferred.each(&:call)
  end
end