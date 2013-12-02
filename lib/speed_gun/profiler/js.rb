require 'speed_gun/profiler/base'

class SpeedGun::Profiler::Js < SpeedGun::Profiler::Base
  def self.profile(profiler, title, elapsed_time, backtrace)
    profile = new
    profiler.profiles << profile
    profile.save(title, elapsed_time, backtrace)
  end

  attr_reader :title

  def save(title, elapsed_time, backtrace)
    @title = title.to_s
    @elapsed_time = elapsed_time.to_i * 0.001
    @backtrace = backtrace
  end
end
