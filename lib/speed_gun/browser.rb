require 'speed_gun'
require 'useragent'

class SpeedGun::Browser
  def initialize(hash)
    @user_agent = UserAgent.parse(hash['user_agent'] || '')
    @navigation = Navigation.new(hash['navigation'] || {})
    @timing = Timing.new(hash['timing'] || {})
  end
  attr_reader :user_agent, :navigation, :timing

  def as_msgpack(*args)
    {
      user_agent: @user_agent.to_s,
      navigation: @navigation,
      timing: @timing,
    }
  end
end

require 'speed_gun/browser/navigation'
require 'speed_gun/browser/timing'
