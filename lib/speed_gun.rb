require 'thread'

module SpeedGun
  def self.current
    Thread.current[:speed_gun_current]
  end

  def self.current=(profiler)
    Thread.current[:speed_gun_current] = profiler
  end

  def self.config
    @config ||= SpeedGun::Config.new
  end

  def self.config=(config)
    @config = config
  end

  def self.active?
    current && current.active?
  end

  def self.enable?
    config.enable?
  end

  def self.store
    config.store
  end
end

require 'speed_gun/version'
require 'speed_gun/config'

if defined?(Rails)
  require 'speed_gun/railtie'
end
