require 'speed_gun/store/base'

class SpeedGun::Store::Memory < SpeedGun::Store::Base
  DEFAULT_MAX_ENTRIES = 100

  def initialize(options)
    @max_entries = options[:max_entries] || DEFAULT_MAX_ENTRIES
    @store = {}
    @stored_list = []
  end

  def [](id)
    @store[id]
  end

  def []=(id, val)
    @store[id] = val
    @stored_list.push(id)

    while @stored_list.length > @max_entries
      @store.delete(@stored_list.shift)
    end
  end
end
