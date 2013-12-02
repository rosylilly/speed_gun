require 'speed_gun'
require 'speed_gun/middleware'

class SpeedGun::Railtie < ::Rails::Railtie
  initializer 'speed_gun' do |app|
    app.middleware.insert(0, SpeedGun::Middleware)

    SpeedGun.config[:enable_on] = -> { Rails.env.development? }
    SpeedGun.config[:backtrace_remove] = Rails.root.to_s + '/'
    SpeedGun.config[:backtrace_includes] = [/^(app|config|lib|test|spec)/]
    SpeedGun.config[:authorize_proc] = ->(request) { Rails.env.development? }
    SpeedGun.config.skip_paths << /^#{Regexp.escape(app.config.assets.prefix)}/

    ActiveSupport.on_load(:action_controller) do
      require 'speed_gun/profiler/action_controller'
    end

    ActiveSupport.on_load(:action_view) do
      require 'speed_gun/profiler/action_view'
    end

    ActiveSupport.on_load(:active_record) do
      require 'speed_gun/profiler/active_record'

      SpeedGun::Profiler::ActiveRecord.hook_method(
        ActiveRecord::Base.connection.class,
        :execute
      )
    end
  end
end
