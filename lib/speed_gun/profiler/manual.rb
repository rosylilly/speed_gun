require 'speed_gun/profiler/base'

class SpeedGun::Profiler::Manual < SpeedGun::Profiler::Base
  def self.label
    'Manual'
  end

  attr_reader :title, :html

  def before_profile(title, html = '')
    @title = title
    @html = html
  end
end
