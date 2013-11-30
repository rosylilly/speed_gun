require 'securerandom'

class SpeedGun::Profiler
  PROFILERS = {}

  def initialize(env)
    @env = env
    @path = env['PATH_INFO']
    @id = SecureRandom.uuid
    @profiles = []
    @active = true
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

  def active?
    @active
  end

  def active!
    @active = true
  end

  def deactive!
    @active = false
  end
end
