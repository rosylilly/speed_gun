require 'speed_gun/profiler/base'

class SpeedGun::Profiler::ManualProfiler < SpeedGun::Profiler::Base
  def self.label
    'Manual'
  end

  def before_profile(title)
    @title = title
  end
end
