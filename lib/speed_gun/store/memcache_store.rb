require 'speed_gun/store'

class SpeedGun::Store::MemcacheStroe < SpeedGun::Store
  DEFAULT_PREFIX = 'speed-gun'
  DEFAULT_EXPIRES_IN_SECONDS = 60 * 60 * 24

  def initialize(options = {})
    @prefix = options[:prefix] || DEFAULT_PREFIX
    @client = options[:client] || default_client(options)
    @expires = (options[:expires] || DEFAULT_EXPIRES_IN_SECONDS).to_i
  end

  def save(object)
    @client.set(
      key(object.class, object.id),
      object.to_hash.to_msgpack,
      @expires
    )
  end

  def load(klass, id)
    klass.from_hash(id, MessagePack.unpack(@client.get(key(klass, id))))
  end

  private

  def key(klass, id)
    klass_name = klass.name
    klass_name.gsub!(/([a-z])([A-Z])/) { |c| "#{$1.to_s}_#{$2.to_s.downcase}" }
    klass_name.gsub!(/[A-Z]/) { |c| "#{c.downcase}" }
    klass_name.gsub!('::', '-')

    [@prefix, klass_name, id].join('-')
  end

  def default_client(options)
    require 'dalli' unless defined?(Dalli)
    Dalli.new(options)
  end
end
