require 'speed_gun/profiler/active_support_notifications_profiler'

class SpeedGun::Profiler::ActionControllerProfiler <
  SpeedGun::Profiler::ActiveSupportNotificatiosProfiler

  subscribe(
    /^(process_action|send_file|send_data|redirect_to)\.action_controller$/,
    [:request]
  )

  def self.name
    'action_controller'
  end
end
