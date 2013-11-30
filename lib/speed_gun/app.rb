require 'speed_gun'
require 'sinatra/base'

class SpeedGun::App < Sinatra::Base
  get '/' do
    "SpeedGun v#{SpeedGun::VERSION}"
  end
end
