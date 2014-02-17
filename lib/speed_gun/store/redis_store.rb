require 'msgpack'
require 'speed_gun/store'

class SpeedGun::Store::RedisStore < SpeedGun::Store
  DEFAULT_PREFIX = 'speed-gun'
  DEFAULT_EXPIRES_IN_SECONDS = 60 * 60 * 24

  def initialize(options = {})
    @prefix = options[:prefix] || DEFAULT_PREFIX
    @client = options[:client] || default_redis(options)
    @expires = (options[:expires] || DEFAULT_EXPIRES_IN_SECONDS).to_i
  end

  def save(object)
    @client.setex(
      key(object.class, object.id),
      @expires,
      object.to_hash.to_msgpack
    )
  end

  def load(klass, id)
    klass.from_hash(id, MessagePack.unpack(@client.get(key(klass, id))))
  end

  private

  def key(klass, id)
    klass_name = klass.name
    klass_name.gsub!(/[A-Z]/) { |c| "_#{c.downcase}" }
    klass_name.gsub!('::', '-')

    [@prefix, klass_name, id].join('-')
  end

  def default_redis(args)
    require 'redis' unless defined? Redis
    Redis.new(args)
  end
end
