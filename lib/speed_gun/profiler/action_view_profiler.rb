require 'speed_gun/profiler/active_support_notifications_profiler'

class SpeedGun::Profiler::ActionViewProfiler <
  SpeedGun::Profiler::ActiveSupportNotificatiosProfiler

  subscribe /^!(render_template|render_partial)\.action_view$/

  def self.name
    'action_view'
  end
end
