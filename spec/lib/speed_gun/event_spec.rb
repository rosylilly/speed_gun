require 'spec_helper'

describe SpeedGun::Event do
  let(:profile) { SpeedGun::Profile.new }
  let(:event_name) { 'spec.test' }

  subject(:event) { described_class.new(event_name, profile.id) }

  describe '#profile_id' do
    subject { event.profile_id }

    it { should be_kind_of(String) }
    it { should eq(profile.id) }
  end

  describe '#id' do
    subject { event.id }

    it { should be_kind_of(String) }
  end

  describe '#name' do
    subject { event.name }

    it { should be_kind_of(String) }
    it { should eq(event_name) }
  end

  describe '#started_at' do
    subject { event.started_at }

    it { should be_kind_of(Time) }
  end

  describe '#finished_at' do
    subject { event.finished_at }

    context 'when finished event' do
      before { event.finish! }

      it { should be_kind_of(Time) }
    end

    context 'when continues event' do
      it { should be_nil }
    end
  end

  describe '#finish!' do
    it 'finishes the event' do
      expect(event).to_not be_finished
      event.finish!
      expect(event).to be_finished
    end
  end

  describe '#duration' do
    subject(:duration) { event.duration }

    context 'when continues event' do
      it { should eq(-1) }
    end

    context 'when finished event' do
      before { event.finish! }

      it { should be_kind_of(Float) }
    end
  end
end
