require 'speed_gun/profiler'
require 'securerandom'

class SpeedGun::Profiler::Base
  def self.label
    self.name.sub(/.*::/, '')
  end

  def self.profiler_type
    self.name\
      .sub(/.*::/, '')\
      .gsub(/(.)([A-Z])/) { |m| "#{$1}_#{$2.downcase}" }\
      .downcase\
      .to_sym
  end

  def self.inherited(klass)
    SpeedGun::Profiler::PROFILERS[klass.profiler_type] = klass
  end

  def self.hook_method(klass, method_name)
    without_profiling = "#{method_name}_withtout_profile".intern
    with_profiling = "#{method_name}_with_profile".intern
    return unless klass.send(:method_defined?, method_name)
    return if klass.send(:method_defined?, with_profiling)

    profiler = self.profiler_type
    klass.send(:alias_method, without_profiling, method_name)
    klass.send(:define_method, with_profiling) do |*args, &block|
      return send(without_profiling, *args, &block) unless SpeedGun.current

      profile_args = [self] + args
      SpeedGun.current.profile(profiler, *profile_args) do
        send(without_profiling, *args, &block)
      end
    end
    klass.send(:alias_method, method_name, with_profiling)
  end

  def self.load(data)
    data.delete('title')
    data.delete('label')
    type = data.delete('type')
    profiler = SpeedGun::Profiler::PROFILERS[type.to_sym]
    profile = profiler.new

    data.each_pair do |key, val|
      profile.send(:instance_variable_set, :"@#{key}", val)
    end

    profile
  end

  def self.profile(profiler, *args, &block)
    profile = new
    profiler.profiles << profile
    profile.profile(*args, &block)
  end

  def initialize
    @id = SecureRandom.uuid
    @parent_profile_id = nil
    @elapsed_time = 0
    @backtrace = []
  end
  attr_reader :id, :elapsed_time, :parent_profile_id, :backtrace

  def title
    warn "Override this method"
  end

  def html
    ""
  end

  def label
    self.class.label
  end

  def type
    self.class.profiler_type
  end

  def profile(*args, &block)
    @backtrace = caller(3).map { |backtrace|
      backtrace.sub(SpeedGun.config.backtrace_remove, '')
    }.reject { |backtrace|
      !SpeedGun.config.backtrace_includes.any? { |regexp|
        backtrace =~ regexp
      }
    }
    parent_profile = SpeedGun.current.now_profile
    SpeedGun.current.now_profile = self
    before_profile(*args, &block) if respond_to?(:before_profile)
    now = Time.now
    result = yield
    @elapsed_time = Time.now - now
    after_profile(*args, &block) if respond_to?(:after_profile)
    return result
  ensure
    SpeedGun.current.now_profile = parent_profile
    @parent_profile_id = parent_profile.id if parent_profile
  end

  def as_msgpack(*args)
    hash = {}
    instance_variables.each do |key|
      unless key.to_s =~ /^\@_/
        hash[key.to_s.sub(/^\@/, '')] = instance_variable_get(key)
      end
    end
    hash['type'] = type.to_s
    hash['label'] = label
    hash['title'] = title
    hash
  end

  def to_msgpack(*args)
    as_msgpack(*args).to_msgpack(*args)
  end
end
