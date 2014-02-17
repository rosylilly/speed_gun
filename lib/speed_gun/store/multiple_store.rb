require 'speed_gun/store'

class SpeedGun::Store::MultipleStore < SpeedGun::Store
  def initialize(stores = [])
    @stores = stores
  end

  def save(object)
    @stores.each do |store|
      store.save(object)
    end
  end

  def load(klass, id)
    @stores.each do |store|
      ret = store.load(klass, id)

      return ret if ret
    end

    nil
  end
end
