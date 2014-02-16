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
end
