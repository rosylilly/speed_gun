require 'speed_gun/profiler/base'

class SpeedGun::Profiler::ActionController < SpeedGun::Profiler::Base
  hook_method ::ActionController::Base, :process

  def title
    @action_name
  end

  def before_profile(controller, action)
    @action_name = "#{controller.class.name}##{action}"
  end
end
