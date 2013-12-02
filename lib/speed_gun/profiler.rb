require 'speed_gun'
require 'speed_gun/store'
require 'speed_gun/browser'
require 'speed_gun/hook'
require 'speed_gun/profiler/manual_profiler'
require 'securerandom'
require 'msgpack'
require 'multi_json'

class SpeedGun::Profiler
  PROFILERS = {}

  def self.load(id)
    src = SpeedGun.store[id]

    return nil unless src

    data = MessagePack.unpack(src)

    profiler = new({})
    profiler.restore_by_hash(data)

    profiler
  end

  def initialize(env)
    @id = SecureRandom.uuid
    @path = env['PATH_INFO']
    @query = env['QUERY_STRING']
    @env = env
    @requested_at = Time.now
    @profiles = []
    @browser = nil
    @active = true
    @now_profile = nil
  end
  attr_reader :id, :path, :query, :env, :requested_at, :profiles, :browser
  attr_accessor :now_profile

  def profile(type, *args, &block)
    profiler = PROFILERS[type]

    if profiler
      profiler.profile(self, *args, &block)
    else
      yield
    end
  end

  def skip?
    SpeedGun.config.skip_paths.any? { |prefix| prefix.match(@path) }
  end

  def active?
    @active && !skip?
  end

  def activate!
    @active = true
  end

  def deactivate!
    @active = false
  end

  def dump
    SpeedGun.store[id] = to_msgpack

    SpeedGun::Hook.invoke_all(self)
  end

  def browser=(hash)
    @browser = SpeedGun::Browser.new(hash)
  end

  def as_msgpack(*args)
    {
      id: @id,
      path: @path,
      query: @query,
      env: msgpackable_env,
      requested_at: @requested_at.to_i,
      profiles: @profiles.map { |profile| profile.as_msgpack(*args) },
      browser: @browser ? @browser.as_msgpack(*args) : nil,
    }
  end

  def to_msgpack(*args)
    as_msgpack(*args).to_msgpack(*args)
  end

  def to_json(*args)
    MultiJson.dump(as_msgpack(*args))
  end

  def restore_by_hash(hash)
    hash.each_pair do |key, val|
      instance_variable_set(:"@#{key}", restore_attribute(key, val))
    end
  end

  def restore_attribute(key, val)
    case key
    when 'requested_at'
      Time.at(val)
    when 'profiles'
      val.map { |profile| SpeedGun::Profiler::Base.load(profile) }
    when 'browser'
      val ? SpeedGun::Browser.new(val) : val
    else
      val
    end
  end

  private

  def msgpackable_env
    env = {}
    @env.each_pair { |key, val| env[key] = val if key[0] =~ /[A-Z]/ }
    env
  end
end
