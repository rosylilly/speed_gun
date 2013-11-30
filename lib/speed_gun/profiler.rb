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

  def profile(type, *args, &block)
    profiler = PROFILERS[type]

    if profiler
      profiler.profile(self, *args, &block)
    else
      yield
    end
  end
end
