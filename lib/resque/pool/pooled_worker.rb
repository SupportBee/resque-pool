require 'resque/worker'

# TODO: Add tests
class Resque::Worker
  alias_method :__initialize, :initialize

  def initialize(*args)
    @__original_pid = Process.pid
    __initialize(*args)
  end

  alias_method :__shutdown?, :shutdown?

  def shutdown?
    return true if __shutdown?
    pooled? && pool_master_has_gone_away?
  end

  private

  def pooled?
    @__original_pid != Process.pid
  end

  def pool_master_has_gone_away?
    Process.ppid == 1
  end
end
