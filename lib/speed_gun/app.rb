require 'speed_gun'
require 'sinatra/base'
require 'pathname'

class SpeedGun::App < Sinatra::Base
  configure do
    root_dir = File.join(File.dirname(__FILE__), 'app')
    set :root, root_dir
    set :public_folder, File.join(root_dir, 'public')
    set :views, File.join(root_dir, 'views')
  end

  get '/' do
    "SpeedGun v#{SpeedGun::VERSION}"
  end
end
