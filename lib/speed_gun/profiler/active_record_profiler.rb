require 'speed_gun/profiler'

class SpeedGun::Profiler::ActiveRecordProfiler < SpeedGun::Profiler
  ActiveSupport::Notifications.subscribe(
    'sql.active_record'
  ) do |name, started, finished, uuid, payload|
    event = SpeedGun::Event.new(
      'active_record.sql', SpeedGun.current_profile.id,
      payload, started, finished
    )
    SpeedGun.current_profile.record!(event)
  end

  ActiveSupport::Notifications.subscribe(
    'identity.active_record'
  ) do |name, started, finished, uuid, payload|
    event = SpeedGun::Event.new(
      'active_record.identity', SpeedGun.current_profile.id,
      payload, started, finished
    )
    SpeedGun.current_profile.record!(event)
  end
end
