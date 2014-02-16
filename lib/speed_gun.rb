require 'thread'
require 'speed_gun/version'
require 'speed_gun/config'
require 'speed_gun/profile'

module SpeedGun
  class << self
    # @return [SpeedGun::Config] the config of speed gun
    def config
      @config ||= Config.new
    end

    # @return [SpeedGun::Profile, nil] the profile of a current thread
    def current_profile
      Thread.current[:speed_gun_current_profile]
    end

    # Set the profile of a current thread
    #
    # @param profile [SpeedGun::Profile] the profile
    # @return [SpeedGun::Profile] the profile of a current thread
    def current_profile=(profile)
      Thread.current[:speed_gun_current_profile] = profile
    end
  end
end
