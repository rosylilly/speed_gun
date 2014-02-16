require 'securerandom'
require 'speed_gun'
require 'speed_gun/event'

class SpeedGun::Profile
  # @return [String] profile ID
  attr_reader :id

  # @return [Array<SpeedGun::Event>] recorded events
  attr_reader :events

  # @return [SpeedGun::Profile] instance of SpeedGun::Profile
  def initialize
    @id = SecureRandom.uuid
    @events = []
  end

  # Record an event
  #
  # @param event [SpeedGun::Event] record event
  # @return [Array<SpeedGun::Event>] recorded events
  def record!(event)
    @events.push(event)
  end
end
