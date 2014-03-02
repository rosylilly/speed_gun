require 'forwardable'
require 'thread'
require 'speed_gun/version'
require 'speed_gun/config'
require 'speed_gun/profile'
require 'speed_gun/middleware'

module SpeedGun
  class << self
    # @return [SpeedGun::Config] the config of speed gun
    def config
      @config ||= Config.new
    end

    # @return [SpeedGun::Profile, nil] the profile of a current thread
    def current_profile
      Thread.current[:speed_gun_current_profile] ||= SpeedGun::Profile.new
    end

    # Set the profile of a current thread
    #
    # @param profile [SpeedGun::Profile] the profile
    # @return [SpeedGun::Profile] the profile of a current thread
    def current_profile=(profile)
      Thread.current[:speed_gun_current_profile] = profile
    end

    # Discard the profile of a current thread
    #
    # @return [nil]
    def discard_profile!
      self.current_profile = nil
    end

    # @return [SpeedGun::Config] the config of a current profile
    def current_config
      current_profile.config
    end

    # @see SpeedGun::Config#enabled?
    # @return [Boolean] true if enabled speed gun
    def enabled?
      config.enabled?
    end

    # @see SpeedGun::Profiler#profile
    def profile(*args, &block)
      current_config.default_profiler.profile(*args, &block)
    end
  end
end

require 'speed_gun/railtie' if defined?(Rails)
