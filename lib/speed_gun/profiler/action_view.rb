require 'speed_gun/profiler/base'

class SpeedGun::Profiler::ActionView < SpeedGun::Profiler::Base
  hook_method ::ActionView::Template, :render

  def title
    @template_path
  end

  def before_profile(action_view, *args)
    @template_path = action_view.instance_variable_get(:@virtual_path)
  end
end

