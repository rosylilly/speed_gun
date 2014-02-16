require 'securerandom'
require 'speed_gun/event'

module SpeedGun
  class Profile
    attr_reader :id, :events

    def initialize
      @id = SecureRandom.uuid
      @events = []
    end
  end
end
