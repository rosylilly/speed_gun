require 'speed_gun/store'

class SpeedGun::Store::ElasticSearchStore < SpeedGun::Store
  DEFAULT_PREFIX = 'speed_gun'

  def initialize(options = {})
    @prefix = options[:prefix] || DEFAULT_PREFIX
    @client = options[:client] || default_clinet(options)
  end

  def save(object)
    @client.index(
      index: index(object.class),
      type: underscore(object.class.name),
      id: object.id,
      body: object.to_hash
    )
  end

  def load(klass, id)
    hit = @client.search(
      index: index(klass),
      body: {
        query: {
          match: {
            "_id" => id
          }
        }
      }
    )['hits']['hits'].first['_source']

    klass.from_hash(id, hit)
  end

  private

  def index(klass)
    [@prefix, underscore(klass.name)].join('-')
  end

  def underscore(name)
    name = name
    name.sub!(/^[A-Z]/) { |c| c.downcase }
    name.gsub!(/[A-Z]/) { |c| "_#{c.downcase}" }
    name.gsub!('::', '')
  end

  def default_clinet(options)
    require 'elasticsearch' unless defined?(Elasticsearch)
    Elasticsearch::Client.new(options)
  end
end
