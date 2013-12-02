require 'speed_gun'

class SpeedGun::Browser
  def initialize(hash)
    @user_agent = hash['user_agent']
    @navigation = hash['navigation']
    @timing = hash['timing']
  end

  def as_msgpack(*args)
    {
      user_agent: @user_agent,
      navigation: @navigation,
      timing: @timing,
    }
  end
end
