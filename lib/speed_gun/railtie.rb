require 'speed_gun'
require 'speed_gun/middleware'

class SpeedGun::Railtie < ::Rails::Railtie
  initializer 'speed_gun' do |app|
    app.middleware.insert(0, SpeedGun::Middleware)
  end
end
