require 'speed_gun'
require 'speed_gun/app'
require 'speed_gun/template'
require 'speed_gun/profiler/rack_profiler'

class SpeedGun::Middleware
  BODY_END_REGEXP = /<\/(?:body|html)>/i

  # @param app [#call] Rack application
  # @return [SpeedGun::Middleware] a instance of SpeedGun::Middleware
  def initialize(app)
    @app = app
  end

  # Handle rack request
  #
  # @return [Rack::Response]
  def call(env)
    return call_with_speed_gun_app(env) if under_speed_gun?(env)

    if with_speed_gun?(env)
      call_with_speed_gun(env)
    else
      call_without_speed_gun(env)
    end
  end

  private

  def under_speed_gun?(env)
    SpeedGun.enabled? && env['PATH_INFO'].match(/^#{SpeedGun.config.prefix}/x)
  end

  def with_speed_gun?(env)
    SpeedGun.enabled? && !skip?(env['PATH_INFO'])
  end

  def skip?(path)
    SpeedGun.config.skip_paths.any? { |regexp| regexp.match(path) }
  end

  def call_with_speed_gun_app(env)
    env['PATH_INFO'].sub!(/\A#{Regexp.escape(SpeedGun.config.prefix)}/, '')

    SpeedGun::App.call(env)
  end

  def call_without_speed_gun(env)
    @app.call(env)
  end

  def call_with_speed_gun(env)
    SpeedGun.current_profile.activate!
    SpeedGun.current_profile.request_method = env['REQUEST_METHOD'].to_s.upcase
    SpeedGun.current_profile.path = env['PATH_INFO'].to_s
    SpeedGun.current_profile.query = env['QUERY_STRING'].to_s

    status, headers, body = SpeedGun::Profiler::RackProfier.profile do
      call_without_speed_gun(env)
    end
    response = Rack::Response.new([], status, headers)

    SpeedGun.current_profile.status = status

    if SpeedGun.current_profile.active?
      inject_profile_id(response)

      if inject_body?(response)
        inject_body(response, body)
      else
        response.write(body)
      end
    end

    response.finish
  ensure
    if SpeedGun.current_profile.active?
      SpeedGun.config.store.save(SpeedGun.current_profile)
    end
    SpeedGun.discard_profile!
  end

  def set_profile_id_tracking?
    (
      SpeedGun.current_config.browser_profiling &&
      SpeedGun.current_profile.request_method == 'GET'
    )
  end

  def inject_profile_id(response)
    response['X-SpeedGun-Profile-Id'] = SpeedGun.current_profile.id
    response.set_cookie(
      SpeedGun.current_config.cookie_name,
      SpeedGun.current_profile.id
    ) if set_profile_id_tracking?
  end

  def inject_body?(response)
    (
      SpeedGun.current_config.auto_inject? &&
      response['Content-Type'] =~ /text\/html/
    )
  end

  def inject_body(response, body)
    body = [body] if body.kind_of?(String)
    body.each { |fragment| response.write(inject_fragment(fragment)) }
    body.close if body.respond_to?(:close)
  end

  def inject_fragment(body)
    return body unless body.match(BODY_END_REGEXP)

    body.sub(BODY_END_REGEXP) do |matched|
      SpeedGun::Template.render + matched
    end
  end
end
