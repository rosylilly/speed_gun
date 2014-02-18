require 'speed_gun'

# @abstract
class SpeedGun::Profiler
  def self.profile(*args, &block)
    new.profile(*args, &block)
  end

  def profile(name = self.class.name, payload = {}, &block)
    starts_at = Time.now

    ret = yield

    event = SpeedGun::Event.new(
      name, payload, starts_at, Time.now
    )
    SpeedGun.current_profile && SpeedGun.current_profile.record!(event)

    return ret
  end
end
