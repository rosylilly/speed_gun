require 'speed_gun/profiler/base'

class SpeedGun::Profiler::ManualProfiler < SpeedGun::Profiler::Base
  def self.label
    'Manual'
  end

  attr_reader :html

  def before_profile(title, html = '')
    @title = title
    @html = html
  end
end
