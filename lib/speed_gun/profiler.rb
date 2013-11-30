require 'speed_gun'
require 'speed_gun/store'
require 'securerandom'

class SpeedGun::Profiler
  PROFILERS = {}

  def self.load(id)
    data = MessagePack.unpack(SpeedGun.store[id])

    profiler = new({})

    data.each_pair do |key, val|
      case key
      when "requested_at"
        val = Time.at(val)
      when "profiles"
        val = val.map { |profile| SpeedGun::Profiler::Base.load(profile) }
      end
      profiler.set_instance_variable(:"@#{key}", val)
    end
  end

  def initialize(env)
    @path = env['PATH_INFO']
    @query = env['QUERY_STRING']
    @env = env
    @requested_at = Time.now
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

  def dump
    SpeedGun.store[id] = to_msgpack
  end

  def as_msgpack(*args)
    {
      id: @id,
      path: @path,
      query: @query,
      env: msgpackable_env,
      requested_at: @requested_at.to_i,
      profiles: @profiles.map { |profile| profile.as_msgpack(*args) },
    }
  end

  def to_msgpack(*args)
    as_msgpack(*args).to_msgpack
  end

  private

  def msgpackable_env
    env = {}
    @env.each_pair do |key, val|
      if key[0] =~ /[A-Z]/
        env[key] = val
      end
    end
    env
  end
end
