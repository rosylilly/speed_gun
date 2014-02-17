require 'speed_gun'
require 'slim'

class SpeedGun::Template < Slim::Template
  TEMPLATE_PATH =
    File.join(File.dirname(__FILE__), 'app/views/meter.html.slim')

  def self.render
    new.render(SpeedGun.current_profile)
  end

  def initialize
    super(TEMPLATE_PATH, pretty: false)
  end
end
