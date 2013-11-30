require 'speed_gun'

class SpeedGun::Config < Hash
  def enable?
    enable && enable_on.call
  end

  def enable
    fetch(:enable, true)
  end

  def enable_on
    self[:enable_on] ||= lambda { true }
  end

  def prefix
    self[:prefix] ||= '/speed_gun'
  end
end
