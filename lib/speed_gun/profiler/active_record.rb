require 'speed_gun/profiler/base'

class SpeedGun::Profiler::ActiveRecord < SpeedGun::Profiler::Base
  def title
    @sql
  end

  def before_profile(adapter, sql, name = nil)
    @sql = sql
    @name = name
  end
end
