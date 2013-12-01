require 'speed_gun/profiler/base'

class SpeedGun::Profiler::ActiveRecord < SpeedGun::Profiler::Base
  def title
    "#{@name}"
  end

  def html
    %Q{<pre class="sql">#{@sql}</pre>}
  end

  def before_profile(adapter, sql, name = nil)
    @sql = sql
    @name = name
  end
end
