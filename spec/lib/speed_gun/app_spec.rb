require 'spec_helper'
require 'rack/test'

describe SpeedGun::App do
  include Rack::Test::Methods

  let(:app) { described_class }

  describe 'GET /js/speed_gun.js' do
    subject(:response) { get '/js/speed_gun.js' }

    it { should be_ok }
  end

  describe 'GET /version' do
    subject(:response) { get '/version' }

    it { should be_ok }

    describe '#body' do
      subject { response.body }

      it { should eq(SpeedGun::VERSION) }
    end
  end
end
