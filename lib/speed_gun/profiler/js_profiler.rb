require 'speed_gun/profiler/base'

class SpeedGun::Profiler::JsProfiler < SpeedGun::Profiler::Base
  def self.profile(profiler, title, elapsed_time)
    profile = new
    profiler.profiles << profile
    profile.save(title, elapsed_time)
  end

  attr_reader :title

  def save(title, elapsed_time)
    @title = title.to_s
    @elapsed_time = elapsed_time.to_i * 0.001
  end
end
