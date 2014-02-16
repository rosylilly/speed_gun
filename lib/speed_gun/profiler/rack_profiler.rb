require 'speed_gun/profiler'

class SpeedGun::Profiler::RackProfier
  def self.profile(env, &block)
    new.profile('rack.total', env, &block)
  end
end
