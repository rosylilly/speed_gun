require 'speed_gun'
require 'speed_gun/profiler'
require 'speed_gun/profiler/rack'

class SpeedGun::Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    SpeedGun.current = SpeedGun::Profiler.new(env) if SpeedGun.enable?

    return @app.call unless SpeedGun.active?

    status, headers, body = *SpeedGun.current.profile(:rack) { @app.call(env) }
    inject_header(headers)

    return [status, headers, body]
  end

  private

  def inject_header(headers)
    return unless SpeedGun.active?

    headers['X-SPEEDGUN-ID'] = SpeedGun.current.id if headers.kind_of?(Hash)
  end
end
