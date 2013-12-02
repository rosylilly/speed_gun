require 'speed_gun/profiler/base'

class SpeedGun::Profiler::ActionController < SpeedGun::Profiler::Base
  hook_method ::ActionController::Base, :process

  attr_reader :action_name
  alias_method :title, :action_name

  def before_profile(controller, action)
    @action_name = "#{controller.class.name}##{action}"
  end
end
