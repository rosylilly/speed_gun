require 'speed_gun/store/base'
require 'fileutils'

class SpeedGun::Store::File
  DEFAULT_PATH = '/tmp/speed_gun'
  DEFAULT_EXPIRES_IN_SECONDS = 60 * 60 * 24
  CLEANUP_INTERVAL = 60 * 60

  def initialize(options = {})
    @path = (options[:path] || DEFAULT_PATH).to_s
    @expires = options[:expires] || DEFAULT_EXPIRES_IN_SECONDS
    @lock = Mutex.new

    this = self
    Thread.new do
      begin
        while true
          this.cleanup
          sleep(CLEANUP_INTERVAL)
        end
      rescue
      end
    end
  end

  def [](id)
    @lock.synchronize {
      read(id) if exist?(id)
    }
  end

  def []=(id, val)
    @lock.synchronize {
      write(id, val)
    }
  end

  def cleanup
    @lock.synchronize {
      files = Dir.entries(@path)
      files.each do |file|
        file = File.join(@path, file)
        File.delete(file) if (Time.now - File.mtime(file)) > @expires
      end
    }
  end

  private

  def read(id)
    File.open(File.join(@path, id), 'rb') { |f| f.read }
  end

  def write(id, val)
    FileUtils.mkdir_p(@path)
    File.open(File.join(@path, id), 'wb+') { |f| f.write(val) }
  end

  def exist?(id)
    File.exist?(File.join(@path, id))
  end
end
