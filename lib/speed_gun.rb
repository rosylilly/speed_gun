require 'thread'

module SpeedGun
  class << self
    attr_writer :config
  end

  def self.current
    Thread.current[:speed_gun_current]
  end

  def self.current=(profiler)
    Thread.current[:speed_gun_current] = profiler
  end

  def self.config
    @config ||= SpeedGun::Config.new
  end

  def self.active?
    current && current.active?
  end

  def self.activate!
    current && current.activate!
  end

  def self.deactivate!
    current && current.deactivate!
  end

  def self.enable?
    config.enable?
  end

  def self.store
    config.store
  end

  def self.profile(title, *args, &block)
    if title.kind_of?(String)
      current && current.profile(:manual, title, &block)
    else
      current && current.profile(title, *args, &block)
    end
  end
end

require 'speed_gun/version'
require 'speed_gun/config'
require 'speed_gun/railtie' if defined?(Rails)
