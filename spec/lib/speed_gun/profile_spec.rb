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
    let(:event) { SpeedGun::Event.new('spec.test') }

    it 'records event' do
      expect(profile.record!(event)).to eq(profile.events)
      expect(profile.events).to include(event)
    end
  end
end
