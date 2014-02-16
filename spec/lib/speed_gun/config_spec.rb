require 'spec_helper'

describe SpeedGun::Config do
  subject(:config) { described_class.new }

  describe '#enable!' do
    before do
      config.disable!
    end

    it 'enables the config' do
      expect(config).to_not be_enabled
      config.enable!
      expect(config).to be_enabled
    end
  end

  describe '#disable!' do
    it 'disables the config' do
      expect(config).to_not be_disabled
      config.disable!
      expect(config).to be_disabled
    end
  end

  describe '#enabled?' do
    it 'defaults to true' do
      expect(config.enabled?).to be_true
    end
  end

  describe '#disabled?' do
    it 'defaults to false' do
      expect(config.disabled?).to be_false
    end
  end
end
