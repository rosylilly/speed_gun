require 'hashie'
require 'speed_gun'
require 'speed_gun/store/memory_store'

class SpeedGun::Config < Hashie::Dash
  # @!attribute [rw]
  # @return [Boolean] true if enabled speed gun
  property :enable, default: true

  # @!attribute [rw]
  # @return [Object, nil] logger of the speed gun
  property :logger, default: nil

  # @!attribute [rw]
  # @return [Array<Regexp>] paths of skip the speed gun
  property :skip_paths, default: []

  # @!attribute [rw]
  # @return [SpeedGun::Store] store of events and profiles
  property :store, default: SpeedGun::Store::MemoryStore.new

  # @!attribute [rw]
  # @return [Boolean] true if enable auto injection
  property :auto_inject, default: true

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

  # @return [Boolean] true if enable auto injection
  def auto_inject?
    auto_inject
  end
end
