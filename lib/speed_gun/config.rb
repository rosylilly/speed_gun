require 'speed_gun'

class SpeedGun::Config < Hash
  def enable?
    enable && enable_if.call
  end

  def enable
    fetch(:enable, true)
  end

  def enable_if
    self[:enable_if] ||= lambda { true }
  end

  def prefix
    self[:prefix] ||= '/speed_gun'
  end

  def prefix_regexp
    self[:prefix_regexp] ||= /^#{Regexp.escape(prefix)}/x
  end

  def store
    self[:store] ||= SpeedGun::Store::Memory.new
  end
end
