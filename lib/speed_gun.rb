require 'speed_gun/version'
require 'speed_gun/config'
require 'speed_gun/profile'

module SpeedGun
  class << self
    # @return [SpeedGun::Config] the config of speed gun
    def config
      @config ||= Config.new
    end
  end
end
