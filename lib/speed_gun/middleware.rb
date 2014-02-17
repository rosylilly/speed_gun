require 'speed_gun'
require 'speed_gun/profiler/rack_profiler'

class SpeedGun::Middleware
  # @param app [#call] Rack application
  # @return [SpeedGun::Middleware] a instance of SpeedGun::Middleware
  def initialize(app)
    @app = app
  end

  # Handle rack request
  #
  # @return [Rack::Response]
  def call(env)
    if with_speed_gun?(env)
      call_with_speed_gun(env)
    else
      call_without_speed_gun(env)
    end
  end

  private

  def with_speed_gun?(env)
    SpeedGun.enabled? && !skip?(env['PATH_INFO'])
  end

  def skip?(path)
    SpeedGun.config.skip_paths.any? { |regexp| regexp.match(path) }
  end

  def call_without_speed_gun(env)
    @app.call(env)
  end

  def call_with_speed_gun(env)
    SpeedGun.current_profile = SpeedGun::Profile.new
    SpeedGun.current_profile.request_method = env['REQUEST_METHOD'].to_s.upcase
    SpeedGun.current_profile.path = env['PATH_INFO'].to_s
    SpeedGun.current_profile.query = env['QUERY_STRING'].to_s

    status, headers, body = SpeedGun::Profiler::RackProfier.profile do
      call_without_speed_gun(env)
    end

    SpeedGun.current_profile.status = status

    if SpeedGun.current_profile.active?
      inject_header(headers)
    end

    [status, headers, body]
  ensure
    if SpeedGun.current_profile.active?
      SpeedGun.config.store.save(SpeedGun.current_profile)
    end
    SpeedGun.discard_profile!
  end

  def inject_header(headers)
    headers['X-SpeedGun-Profile-Id'] = SpeedGun.current_profile.id
  end
end
