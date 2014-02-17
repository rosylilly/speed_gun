require 'spec_helper'

describe SpeedGun::Profile do
  subject(:profile) { described_class.new }

  describe '#id' do
    subject { profile.id }

    it { should be_kind_of(String) }
  end

  describe '#events' do
    subject { profile.events }

    it { should be_kind_of(Array) }
  end

  describe '#record!' do
    let(:logger) { double(debug: nil) }
    let(:event) { SpeedGun::Event.new('spec.test') }

    before { profile.config.logger = logger }

    it 'records event' do
      expect(profile.record!(event)).to eq(profile.events)
      expect(profile.events).to include(event)
    end
  end

  describe '#to_hash' do
    let(:event) { SpeedGun::Event.new('spec.test') }

    before { profile.record!(event) }

    it 'valid serialize' do
      expect(
        SpeedGun::Profile.from_hash(profile.id, profile.to_hash).to_hash
      ).to eq(profile.to_hash)
    end
  end
end
