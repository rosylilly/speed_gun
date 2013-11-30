require 'speed_gun/profiler/base'

class SpeedGun::Profiler::Rack < SpeedGun::Profiler::Base
  def title
    'Rack Total'
  end
end
