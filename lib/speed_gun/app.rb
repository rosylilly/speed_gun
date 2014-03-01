require 'speed_gun'
require 'sinatra/base'

class SpeedGun::App < Sinatra::Base
  configure do
    root_dir = File.join(File.dirname(__FILE__), 'app')
    set :root, root_dir
    set :public_folder, File.join(root_dir, 'assets')
    set :views, File.join(root_dir, 'views')
  end

  get '/version' do
    [200, {}, SpeedGun::VERSION]
  end
end
