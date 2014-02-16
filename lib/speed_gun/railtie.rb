require 'speed_gun'

class SpeedGun::Railtie < ::Rails::Railtie
  initializer 'speed_gun' do |app|
    app.middleware.insert(0, SpeedGun::Middleware)

    SpeedGun.config.logger = Rails.logger
    SpeedGun.config.skip_paths.push(
      /^#{Regexp.escape(app.config.assets.prefix)}/
    )

    ActiveSupport.on_load(:action_controller) do
      require 'speed_gun/profiler/action_controller_profiler'
    end

    ActiveSupport.on_load(:action_view) do
      require 'speed_gun/profiler/action_view_profiler'
    end

    ActiveSupport.on_load(:active_record) do
      require 'speed_gun/profiler/active_record_profiler'
    end
  end
end
