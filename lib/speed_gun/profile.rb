require 'securerandom'
require 'speed_gun'
require 'speed_gun/event'

class SpeedGun::Profile
  # @return [String] Profile ID
  attr_reader :id

  # @return [Array<SpeedGun::Event>] Profile events
  attr_reader :events

  # @return [SpeedGun::Profile] instance of SpeedGun::Profile
  def initialize
    @id = SecureRandom.uuid
    @events = []
  end
end
