require 'speed_gun'

class SpeedGun::Hook
  HOOKS = []

  def self.inherited(klass)
    HOOKS.push(klass) unless HOOKS.include?(klass)
  end

  def self.invoke_all(profiler)
    HOOKS.each { |hook| hook.invoke(profiler) }
  end

  def self.invoke(profiler)
    new(profiler).invoke
  end

  def initialize(profiler)
    @profiler = profiler
  end
  attr_reader :profiler

  def invoke
  end
end
