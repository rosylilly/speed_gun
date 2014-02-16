require 'speed_gun'

class SpeedGun::Event
  # @return [String] Profile ID(UUID)
  attr_reader :profile_id

  # @return [String] Event ID(UUID)
  attr_reader :id

  # @return [String] Event name
  attr_reader :name

  # @return [Time] Start time
  attr_reader :started_at

  # @return [Time, nil] Finish time
  attr_reader :finished_at
end
