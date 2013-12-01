require 'speed_gun'
require 'sinatra/base'

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

  get '/profile/:id' do
    @profiler = SpeedGun::Profiler.load(params[:id])

    halt 404 unless @profiler

    if params[:format] == 'json'
      return [200, {'Content-Type' => 'application/json'}, @profiler.to_json]
    end

    slim :profile
  end
end
