require 'speed_gun'

# @abstruct
class SpeedGun::Profiler
  def profile(name, payload = {}, &block)
    event = SpeedGun::Event.new(name, SpeedGun.current_profile.id, payload)

    ret = yield

    event.finish!

    return ret
  end
end
