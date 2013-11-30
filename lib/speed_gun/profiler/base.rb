require 'speed_gun/profiler'

class SpeedGun::Profiler::Base
  def self.inherited(klass)
    klass_name = klass.name.sub(/.*::/, '')\
      .gsub(/.([A-Z])/) {|m| "_#{$1.downcase}" }.downcase.to_sym

    SpeedGun::Profiler::PROFILERS[klass_name] = klass
  end

  def self.profile(profiler, *args, &block)
    profile = new
    profiler.profiles << profile
    profile.profile(*args, &block)
  end

  def initialize
    @elapsed_time = 0
  end

  def title
    warn "Override this method"
  end

  def profile(*args, &block)
    now = Time.now
    result = yield
    @elapsed_time = Time.now - now
  ensure
    return result
  end
end
