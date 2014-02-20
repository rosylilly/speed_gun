require 'spec_helper'
require 'rack/test'

describe SpeedGun::Middleware do
  include Rack::Test::Methods

  before(:all) do
    SpeedGun.config.skip_paths << '/skip'
  end

  let(:app) do
    builder = Rack::Builder.new do
      use SpeedGun::Middleware

      map '/skip' do
        process = lambda do |env|
          [
            200,
            { 'Content-Type' => 'text/html' },
            "<html><BODY><h1>Skip</h1></BODY>\n \t</html>"
          ]
        end

        run process
      end

      map '/html' do
        process = lambda do |env|
          [
            200,
            { 'Content-Type' => 'text/html' },
            "<html><BODY><h1>Hi</h1></BODY>\n \t</html>"
          ]
        end

        run process
      end

      map '/json' do
        process = lambda do |env|
          [
            200,
            { 'Content-Type' => 'application/json' },
            '{"text":"hi"}'
          ]
        end

        run process
      end
    end
    builder.to_app
  end

  describe 'GET /skip' do
    subject(:response) { get '/skip' }

    it { should be_ok }

    describe '#headers' do
      subject { response.headers }

      it { should_not be_has_key('X-SpeedGun-Profile-Id') }
    end
  end

  describe 'GET /html' do
    subject(:response) { get '/html' }

    it { should be_ok }

    describe '#headers' do
      subject { response.headers }

      it { should be_has_key('X-SpeedGun-Profile-Id') }
    end

    describe '#body' do
      subject { response.body }

      it { should include('speed-gun') }
    end
  end

  describe 'GET /json' do
    subject(:response) { get '/json' }

    it { should be_ok }

    describe '#headers' do
      subject { response.headers }

      it { should be_has_key('X-SpeedGun-Profile-Id') }
    end

    describe '#body' do
      subject { response.body }

      it { should_not include('speed-gun') }
    end
  end
end
