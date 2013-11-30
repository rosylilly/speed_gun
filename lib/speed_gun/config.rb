class SpeedGun::Config < Hash
  def enable?
    !!self[:enable]
  end
end
