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

  post '/profile/:id' do
    @profiler = SpeedGun::Profiler.load(params[:id])

    if @profiler && @profiler.browser.nil?
      @profiler.browser = params[:browser]
      @profiler.dump
    end

    204
  end

  get '/profile/:id.json' do
    @profiler = SpeedGun::Profiler.load(params[:id])
    halt 404 unless @profiler

    [200, {'Content-Type' => 'application/json'}, @profiler.to_json]
  end

  get '/profile/:id' do
    @profiler = SpeedGun::Profiler.load(params[:id])
    halt 404 unless @profiler

    slim :profile
  end
end
