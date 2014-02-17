require 'speed_gun/store'

class SpeedGun::Store::FluentLoggerStore < SpeedGun::Store
  DEFAULT_PREFIX = 'speed_gun'

  def initialize(options = {})
    @prefix = options[:prefix] || DEFAULT_PREFIX
    @logger = options[:logger] || default_logger(options)
  end

  def save(object)
    @logger.post(tag(object), object.to_hash.merge(id: object.id))
  end

  def load(klass, id)
    nil
  end

  private

  def tag(object)
    object.class.name.sub(/.*::/, '').downcase
  end

  def default_logger(options)
    require 'fluent-logger' unless defined?(Fluent::Logger)
    Fluent::Logger::FluentLogger.new(@prefix, options)
  end
end
