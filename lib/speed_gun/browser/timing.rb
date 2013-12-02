require 'speed_gun/browser'

class SpeedGun::Browser::Timing < Hash
  ATTRIBUTES = [
    :navigationStart,
    :unloadEventStart,
    :unloadEventEnd,
    :redirectStart,
    :redirectEnd,
    :fetchStart,
    :domainLookupStart,
    :domainLookupEnd,
    :connectStart,
    :connectEnd,
    :secureConnectionStart,
    :requestStart,
    :responseStart,
    :responseEnd,
    :domLoading,
    :domInteractive,
    :domContentLoadedEventStart,
    :domContentLoadedEventEnd,
    :domComplete,
    :loadEventStart,
    :loadEventEnd,
  ]

  class Timing
    def initialize(name, base, started_at, ended_at)
      @name = name
      @started_at = started_at - base
      @elapsed_time = ended_at - started_at
    end
    attr_reader :name, :started_at, :elapsed_time
  end

  def initialize(hash)
    hash.each_pair do |key, val|
      self[key.to_s.to_sym] = val.to_i
    end
  end

  ATTRIBUTES.each do |key|
    define_method(key) { self[key] }
  end

  def load_time
    loadEventEnd - navigationStart
  end

  def timings
    @timings ||= [
      (redirectStart > 0 ?
       Timing.new('Redirect', navigationStart, redirectStart, redirectEnd) :
       nil
      ),
      Timing.new('Fetch all', navigationStart, fetchStart, responseEnd),
      Timing.new(
        'DNS Lookup', navigationStart, domainLookupStart, domainLookupEnd
      ),
      Timing.new(
        'TCP Connecting', navigationStart, connectStart, connectEnd
      ),
      (secureConnectionStart > 0 ?
        Timing.new('SSL', navigationStart, secureConnectionStart, connectEnd) :
        nil
      ),
      Timing.new('Request', navigationStart, requestStart, responseStart),
      Timing.new('Response', navigationStart, responseStart, responseEnd),
      Timing.new('Unload', navigationStart, unloadEventStart, unloadEventEnd),
      Timing.new('DOM Load', navigationStart, domLoading, domInteractive),
      Timing.new(
        'DOMContentLoaded Event',
        navigationStart, domContentLoadedEventStart, domContentLoadedEventEnd
      ),
      Timing.new(
        'Sub resources loading', navigationStart, domInteractive, domComplete
      ),
      Timing.new('Load Event', navigationStart, loadEventStart, loadEventEnd),
    ].reject { |timing| timing.nil? }
  end
end
