require 'speed_gun/store/base'

class SpeedGun::Store::Memcache
  DEFAULT_PREFIX = 'speed-gun-'
  DEFAULT_EXPIRES_IN_SECONDS = 60 * 60 * 24

  def initialize(options = {})
    @prefix = options[:prefix] || DEFAULT_PREFIX
    @client = options[:client] || default_dalli
    @expires = options[:expires] || DEFAULT_EXPIRES_IN_SECONDS
  end

  def [](id)
    @client.get("#{@prefix}#{id}")
  end

  def []=(id, val)
    @client.set("#{@prefix}#{id}", val, @expires)
  end

  private

  def default_dalli
    require 'dalli' unless defined?(Dalli)
    Dalli::Client.new
  end
end
