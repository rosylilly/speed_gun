require 'speed_gun/profiler'

class SpeedGun::Profiler::ActiveSupportNotificatiosProfiler < SpeedGun::Profiler
  def self.subscribe(event, ignore_payload = [])
    klass = self
    ActiveSupport::Notifications.subscribe(event) do |*args|
      if SpeedGun.current_profile.active?
        klass.record(event, *args, ignore_payload)
      end
    end
  end

  def self.record(event, name, started, ended, id, payload, ignore_payload)
    name = "#{self.name}.#{name.sub(event, '\1')}"

    payload.symbolize_keys!

    ignore_payload.each do |key|
      payload.delete(key)
    end

    payload[:backtrace] = backtrace

    event = SpeedGun::Event.new(name, payload, started, ended)
    SpeedGun.current_profile.record!(event)
  end

  def self.backtrace
    Rails.backtrace_cleaner.clean(caller[2..-1])
  end
end
