require 'securerandom'
require 'speed_gun'
require 'speed_gun/event'

class SpeedGun::Profile
  def self.from_hash(id, hash)
    profile = new

    hash['events'].map! do |event_id|
      SpeedGun.config.store.load(SpeedGun::Event, event_id)
    end

    hash['id'] = id
    hash.delete('duration')
    hash.each_pair do |key, val|
      profile.instance_variable_set(:"@#{key}", val)
    end

    profile
  end

  # @return [String] profile ID
  attr_reader :id

  # @return [Array<SpeedGun::Event>] recorded events
  attr_reader :events

  # @return [SpeedGun::Config] the config of the profile
  attr_reader :config

  # @return [Integer] status code of the response
  attr_accessor :status

  # @return [String] method of the request
  attr_accessor :request_method

  # @return [String] path of the request
  attr_accessor :path

  # @return [String] query of the request
  attr_accessor :query

  # @return [SpeedGun::Profile] instance of SpeedGun::Profile
  def initialize(config = SpeedGun.config.dup)
    @id = SecureRandom.uuid
    @events = []
    @config = config
    @active = true
  end

  # Record an event
  #
  # @param event [SpeedGun::Event] record event
  # @return [Array<SpeedGun::Event>] recorded events
  def record!(event)
    config.logger.debug(
      "[SpeedGun] Record Event: #{event.name}: #{'%0.2f' % (event.duration * 1000)}ms"
    ) if config.logger
    config.store.save(event) if active?
    @events.push(event)
  end

  def active?
    @active
  end

  def deactive?
    !active?
  end

  def activate!
    @active = true
  end

  def deactivate!
    @active = false
  end

  def earliest_started_at
    @events.sort_by(&:started_at).first.started_at
  end

  def latest_finished_at
    @events.sort_by { |event| event.finished_at || 0 }.last.finished_at
  end

  def duration
    finished_at = latest_finished_at
    finished_at ? finished_at - earliest_started_at : 0
  end

  def to_hash
    {
      'events' => events.map(&:id),
      'status' => status,
      'request_method' => request_method,
      'path' => path,
      'query' => query,
      'duration' => duration
    }
  end
end
