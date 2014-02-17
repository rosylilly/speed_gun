require 'speed_gun/profiler/active_support_notifications_profiler'

class SpeedGun::Profiler::ActiveRecordProfiler <
  SpeedGun::Profiler::ActiveSupportNotificatiosProfiler

  subscribe(/\.active_record$/, [:binds])

  def self.name
    'active_record'
  end
end
