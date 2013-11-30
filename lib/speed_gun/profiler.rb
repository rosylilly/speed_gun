require 'securerandom'

class SpeedGun::Profiler
  PROFILERS = {}

  def initialize(env)
    @env = env
    @path = env['PATH_INFO']
    @id = SecureRandom.uuid
    @profiles = []
  end
  attr_reader :id, :profiles

  def profile(type, &block)
    profiler = PROFILERS[type]

    if profiler
      profiler.profile(self, &block)
    else
      yield
    end
  end
end
