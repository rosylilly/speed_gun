require 'speed_gun/profiler'

class SpeedGun::Profiler::RackProfier < SpeedGun::Profiler
  def self.name
    'rack.total'
  end
end
