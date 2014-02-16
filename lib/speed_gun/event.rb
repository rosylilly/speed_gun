require 'speed_gun'

class SpeedGun::Event
  # @return [String] profile ID
  attr_reader :profile_id

  # @return [String] event ID
  attr_reader :id

  # @return [String] event name
  attr_reader :name

  # @return [Time] start time
  attr_reader :started_at

  # @return [Time, nil] finish time
  attr_reader :finished_at

  # @param profile_id [String] profile ID
  # @param name [String] event name
  # @param started_at [Time] start time
  # @param finished_at [Time, nil] finish time
  # @return [SpeedGun::Event] instance of SpeedGun::Event
  def initialize(profile_id, name, started_at = Time.now, finished_at = nil)
    @profile_id = profile_id
    @id = SecureRandom.uuid
    @name = name
    @started_at = started_at
    @finished_at = finished_at
  end

  # Finish event
  #
  # @return [Time] finish time
  def finish!
    @finished_at = Time.now
  end

  # @return [true, false] true if the event is finished
  def finished?
    !@finished_at.nil?
  end
end