require 'speed_gun'
require 'speed_gun/app'
require 'speed_gun/profiler'
require 'speed_gun/profiler/rack'
require 'speed_gun/template'

class SpeedGun::Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    return SpeedGun::App.call(env) if under_speed_gun?(env)

    SpeedGun.current = SpeedGun::Profiler.new(env) if SpeedGun.enable?

    return @app.call(env) unless SpeedGun.active?

    remove_conditional_get_headers(env) if SpeedGun.config.force_profile?

    status, headers, body = *SpeedGun.current.profile(:rack) { @app.call(env) }

    inject_header(headers)
    SpeedGun.current.dump

    if SpeedGun.config.auto_inject? && SpeedGun.active?
      inject_body(status, headers, body)
    else
      return [status, headers, body]
    end
  ensure
    SpeedGun.current = nil
  end

  private

  def remove_conditional_get_headers(env)
    env['HTTP_IF_MODIFIED_SINCE'] = ''
    env['HTTP_IF_NONE_MATCH'] = ''
  end

  def inject_header(headers)
    return unless SpeedGun.active?

    if SpeedGun.config.force_profile?
      headers.delete('ETag')
      headers.delete('Date')
      headers['Cache-Control'] = 'must-revalidate, private, max-age=0'
    end

    headers['X-SPEEDGUN-ID'] = SpeedGun.current.id
  end

  def inject_body(status, headers, body)
    unless headers['Content-Type'] =~ /text\/html/
      return [status, headers, body]
    end

    response = Rack::Response.new([], status, headers)

    if body.kind_of?(String)
      response.write(inject_meter(body))
    else
      body.each { |fragment| response.write(inject_meter(fragment)) }
    end
    body.close if body.respond_to?(:close)

    response.finish
  end

  def inject_meter(body)
    return body unless body.match(%r{</(?:body|html)>})

    body.sub(%r{</(?:body|html)>}) do |matched|
      SpeedGun::Template.render + matched
    end
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
