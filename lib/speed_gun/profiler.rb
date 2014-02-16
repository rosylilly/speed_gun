require 'speed_gun'

# @abstruct
class SpeedGun::Profiler
  def self.profile(*args, &block)
    new.profile(*args, &block)
  end

  def profile(name = self.class.name, payload = {}, &block)
    starts_at = Time.now

    ret = yield

    event = SpeedGun::Event.new(
      name, SpeedGun.current_profile.id, payload, starts_at, Time.now
    )
    SpeedGun.current_profile.record!(event)

    return ret
  end
end
