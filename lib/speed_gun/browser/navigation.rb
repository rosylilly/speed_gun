require 'speed_gun/browser'

class SpeedGun::Browser::Navigation < Hash
  NAVIGATION_TYPES = [
    'Navigate',
    'Reload',
    'Back/Forward'
  ]

  def initialize(hash)
    hash.each_pair do |key, val|
      self[key.to_s.to_sym] = val
    end
  end

  def type
    NAVIGATION_TYPES[self[:type].to_i] || 'Unknown'
  end

  def redirect_count
    self[:redirect_count].to_i
  end
end
