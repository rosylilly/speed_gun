require 'spec_helper'

describe SpeedGun do
  describe '#config' do
    subject { described_class.config }

    it { should be_kind_of(SpeedGun::Config) }
  end

  describe '#current_profile' do
    let(:profile) { double }
    subject(:current_profile) { described_class.current_profile }

    it 'defaults to be nil' do
      expect(current_profile).to be_nil
    end

    it 'thread localy' do
      described_class.current_profile = profile
      expect(current_profile).to eq(profile)

      thread = Thread.new { expect(described_class.current_profile).to be_nil }
      thread.join
    end
  end
end
