require 'speed_gun'

class SpeedGun::Event
  # @return [String] profile ID
  attr_reader :profile_id

  # @return [String] event ID
  attr_reader :id

  # @return [String] event name
  attr_reader :name

  # @return [Hashie::Mash] payload
  attr_reader :payload

  # @return [Time] start time
  attr_reader :started_at

  # @return [Time, nil] finish time
  attr_reader :finished_at

  # @param name [String] event name
  # @param profile_id [String] profile ID
  # @param payload [Hash] payload
  # @param started_at [Time] start time
  # @param finished_at [Time, nil] finish time
  # @return [SpeedGun::Event] instance of SpeedGun::Event
  def initialize(
    name,
    profile_id = SpeedGun.current_profile.id,
    payload = {}, started_at = Time.now, finished_at = nil
  )
    @id = SecureRandom.uuid
    @profile_id = profile_id
    @name = name
    @payload = Hashie::Mash.new(payload)
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

  # Time duration of the event
  #
  # @return [Float] a duration of the event
  def duration
    finished? ? finished_at.to_f - started_at.to_f : -1
  end
end
