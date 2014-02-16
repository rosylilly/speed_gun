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
    if SpeedGun.enabled?
      call_with_speed_gun(env)
    else
      call_without_speed_gun(env)
    end
  end

  private

  def call_without_speed_gun(env)
    @app.call(env)
  end

  def call_with_speed_gun(env)
    SpeedGun.current_profile = SpeedGun::Profile.new

    SpeedGun::Profiler::RackProfier.profile(env) do
      call_without_speed_gun(env)
    end
  ensure
    SpeedGun.discard_profile!
  end
end
