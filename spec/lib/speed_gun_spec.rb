require 'spec_helper'

describe SpeedGun do
  subject { described_class }

  describe '#config' do
    subject { described_class.config }

    it { should be_kind_of(SpeedGun::Config) }
  end

  describe '#current_profile' do
    let(:profile) { double }
    subject(:current_profile) { described_class.current_profile }

    it 'thread localy' do
      described_class.current_profile = profile
      expect(current_profile).to eq(profile)

      thread = Thread.new do
        expect(described_class.current_profile).to_not eq(profile)
      end
      thread.join
    end
  end

  describe '#discard_profile!' do
    let(:profile) { double }

    it 'discards current profile' do
      described_class.current_profile = profile
      described_class.discard_profile!
      expect(described_class.current_profile).to_not eq(profile)
    end
  end

  describe '#enabled?' do
    context 'when enabled' do
      before { described_class.config.stub(enabled?: true) }

      it { should be_enabled }
    end

    context 'when disabled' do
      before { described_class.config.stub(enabled?: false) }

      it { should_not be_enabled }
    end
  end
end
