require 'speed_gun'

class SpeedGun::Railtie < ::Rails::Railtie
  initializer 'speed_gun' do |app|
    app.middleware.insert(0, SpeedGun::Middleware)

    SpeedGun.config.logger = Rails.logger
    SpeedGun.config.skip_paths.push(
      /^#{Regexp.escape(app.config.assets.prefix)}/
    )
  end
end
