require 'speed_gun/store/base'

class SpeedGun::Store::Redis
  DEFAULT_PREFIX = 'speed-gun-'
  DEFAULT_EXPIRES_IN_SECONDS = 60 * 60 * 24

  def initialize(options = {})
    @prefix = options[:prefix] || DEFAULT_PREFIX
    @client = options[:client] || default_redis(options)
    @expires = options[:expires] || DEFAULT_EXPIRES_IN_SECONDS
  end

  def [](id)
    @client.get("#{@prefix}#{id}")
  end

  def []=(id, val)
    @client.setex("#{@prefix}#{id}", val, @expires)
  end

  private

  def default_redis(args)
    require 'redis' unless defined? Redis
    Redis.new(args)
  end
end

