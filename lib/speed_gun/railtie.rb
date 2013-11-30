require 'speed_gun'
require 'speed_gun/middleware'

class SpeedGun::Railtie < ::Rails::Railtie
  initializer 'speed_gun' do |app|
    app.middleware.insert(0, SpeedGun::Middleware)

    ActiveSupport.on_load(:action_controller) do
      require 'speed_gun/profiler/action_controller'
    end

    ActiveSupport.on_load(:action_view) do
      require 'speed_gun/profiler/action_view'
    end
  end
end
