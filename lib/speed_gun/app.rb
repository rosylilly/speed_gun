require 'speed_gun'
require 'sinatra/base'

class SpeedGun::App < Sinatra::Base
  configure do
    root_dir = File.join(File.dirname(__FILE__), 'app')
    set :root, root_dir
    set :public_folder, File.join(root_dir, 'public')
    set :views, File.join(root_dir, 'views')
  end

  helpers do
    def h(str)
      CGI.escapeHTML(str.to_s)
    end
  end

  post '/profile/:id' do
    @profiler = SpeedGun::Profiler.load(params[:id])

    if @profiler
      if @profiler.browser.nil? && params[:browser]
        @profiler.browser = params[:browser]
      end

      if params[:js]
        SpeedGun::Profiler::Js.profile(
          @profiler,
          params[:js]['title'] || '',
          params[:js]['elapsed_time'] || 0,
          params[:js]['backtrace'] || []
        )
      end

      @profiler.dump
    end

    204
  end

  get '/profile/:id.json' do
    halt 404 unless SpeedGun.config.authorize_proc.call(request)

    @profiler = SpeedGun::Profiler.load(params[:id])
    halt 404 unless @profiler

    [200, { 'Content-Type' => 'application/json' }, @profiler.to_json]
  end

  get '/profile/:id' do
    halt 404 unless SpeedGun.config.authorize_proc.call(request)

    @profiler = SpeedGun::Profiler.load(params[:id])
    halt 404 unless @profiler

    slim :profile
  end
end
