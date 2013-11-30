class SpeedGun::Config < Hash
  def enable?
    !!self[:enable] && enable_on.call
  end

  def enable_on
    self[:enable_on] ||= lambda { true }
  end
end
