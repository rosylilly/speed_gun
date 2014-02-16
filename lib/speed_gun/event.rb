require 'speed_gun'

class SpeedGun::Event
  attr_accessor :profile_id, :id, :name, :started_at, :finished_at, :payload
end
