require 'speed_gun/store'

class SpeedGun::Store::MemoryStore < SpeedGun::Store
  DEFAULT_MAX_ENTRIES = 1000

  def initialize(options = {})
    @max_entries = options[:max_entries] || DEFAULT_MAX_ENTRIES
    @store = {}
    @stored_list = []
  end

  def save(object)
    id = "#{object.class.name}-#{object.id}"
    @store[id] = object.to_hash
    @stored_list.push(id)

    @store.delete(@stored_list.shift) while @stored_list.length > @max_entries
  end

  def load(klass, id)
    klass.from_hash(id, @store["#{klass.name}-#{id}"])
  end
end
