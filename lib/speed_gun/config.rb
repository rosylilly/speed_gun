require 'speed_gun'

class SpeedGun::Config < Hash
  def enable?
    enable && enable_if.call
  end

  def enable
    fetch(:enable, true)
  end

  def enable_if
    self[:enable_if] ||= lambda { true }
  end

  def prefix
    self[:prefix] ||= '/speed_gun'
  end

  def prefix_regexp
    self[:prefix_regexp] ||= /^#{Regexp.escape(prefix)}/x
  end

  def store
    self[:store] ||= SpeedGun::Store::Memory.new
  end

  def auto_inject?
    fetch(:auto_inject, true)
  end

  def backtrace_remove
    self[:backtrace_remove] ||= ""
  end

  def backtrace_includes
    self[:backtrace_includes] ||= []
  end

  def show_button?
    fetch(:show_button, true)
  end

  def no_include_jquery?
    fetch(:no_include_jquery, false)
  end

  def skip_paths
    self[:skip_paths] ||= [/favicon/]
  end

  def force_profile?
    fetch(:force_profile, true)
  end

  def authorize_proc
    self[:authorize_proc] ||= lambda { |request| true }
  end
end
