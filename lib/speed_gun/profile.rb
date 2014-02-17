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
  end

  # Record an event
  #
  # @param event [SpeedGun::Event] record event
  # @return [Array<SpeedGun::Event>] recorded events
  def record!(event)
    config.logger.debug(
      "[SpeedGun] Record Event: #{event.name}: #{'%0.2f' % (event.duration * 1000)}ms"
    ) if config.logger
    config.store.save(event)
    @events.push(event)
  end

  def to_hash
    {
      events: events.map(&:id),
      status: status,
      request_method: request_method,
      path: path,
      query: query
    }
  end
end
