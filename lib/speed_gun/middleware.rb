require 'speed_gun'
require 'speed_gun/app'
require 'speed_gun/profiler'
require 'speed_gun/profiler/rack'

class SpeedGun::Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    return SpeedGun::App.call(env) if under_speed_gun?(env)

    SpeedGun.current = SpeedGun::Profiler.new(env) if SpeedGun.enable?

    return @app.call unless SpeedGun.active?

    status, headers, body = *SpeedGun.current.profile(:rack) { @app.call(env) }
    inject_header(headers)

    return [status, headers, body]
  ensure
    SpeedGun.current = nil
  end

  private

  def inject_header(headers)
    return unless SpeedGun.active?

    headers['X-SPEEDGUN-ID'] = SpeedGun.current.id if headers.kind_of?(Hash)
  end

  def under_speed_gun?(env)
    if SpeedGun.config.prefix_regexp.match(env['PATH_INFO'])
      env['PATH_INFO'] =
        env['PATH_INFO'].sub(SpeedGun.config.prefix_regexp, '')
      true
    else
      false
    end
  end
end
