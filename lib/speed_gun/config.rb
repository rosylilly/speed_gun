require 'hashie'
require 'speed_gun'

class SpeedGun::Config < Hashie::Dash
  # @!attribute [rw]
  # @return [Boolean] true if enabled speed gun
  property :enable, default: true

  # @!attribute [rw]
  # @return [Object, nil] logger of the speed gun
  property :logger, default: nil

  # @return [true]
  def enable!
    self[:enable] = true
  end

  # @return [false]
  def disable!
    self[:enable] = false
  end

  # @return [Boolean] true if enabled speed gun
  def enabled?
    !!enable
  end

  # @return [Boolean] true if disabled speed gun
  def disabled?
    !enabled?
  end
end
