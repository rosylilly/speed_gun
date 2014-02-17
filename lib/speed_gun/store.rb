require 'speed_gun'

# @abstract
class SpeedGun::Store
  def save(object)
  end

  def load(klass, id)
  end
end
