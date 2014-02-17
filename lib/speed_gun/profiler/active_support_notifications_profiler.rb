require 'speed_gun/profiler'

class SpeedGun::Profiler::ActiveSupportNotificatiosProfiler < SpeedGun::Profiler
  def self.subscribe(event)
    klass = self
    ActiveSupport::Notifications.subscribe(event) do |*args|
      klass.record(event, *args)
    end
  end

  def self.record(event, name, started, ended, id, payload)
    name = "#{self.name}.#{name.sub(event, '\1')}"

    payload[:backtrace] = backtrace

    event = SpeedGun::Event.new(name, payload, started, ended)
    SpeedGun.current_profile.record!(event)
  end

  def self.backtrace
    Rails.backtrace_cleaner.clean(caller[2..-1])
  end
end
