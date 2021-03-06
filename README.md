# SpeedGun

First, profile. Second, profile.

SpeedGun is a better web app profiler on Rails and Rack apps.

## Installation

Add this line to your application's Gemfile:

    gem 'speed_gun'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install speed_gun

## Usage

### Rails

You don't require settings in development.

In production. You should set `enable_if` and `authorize_proc` configs.

### Sinatra

```ruby
require 'speed_gun'

class MyApplication < Sinatra::Base
  use SpeedGun::Middleware
end
```

## Profiling

### Built-in Profilers

SpeedGun has built-in profilers.

- `SpeedGun::Profiler::ActionController`
- `SpeedGun::Profiler::ActionView`
- `SpeedGun::Profiler::ActiveRecord`
- `SpeedGun::Profiler::Rack`

these profilers don't need configuration.

### Manual Profiling

If you want take profile manually. You can use `SpeedGun.profile` method.

```ruby
SpeedGun.profile("MyProfile#method") do
  my_profile.method()
end
```

### Javascript Profiling

SpeedGun is supporting profiling on javascript. You can use `speedGun.profile` or `speedGun.profileMethod`.

```javascript
speedGun.profile("any title", function() { ... codes ...});

var object = { func: function() { ... codes ... } };
speedGun.profileMethod(object, "func", "any title");
```

And SpeedGun collect browser informations.

- User Agent
- Perfomance API(if implemented)

### Custom Profiler

You can create your custom profilers. a custom profiler require `title` method.

Some examples:

#### SimpleCustomProfiler

```ruby
class SimpleCustomProfiler < SpeedGun::Profiler::Base
  def title
    'simple'
  end
end

SpeedGun.profile(:simple_custom_profiler) { ... }
```

#### BeforeFilterProfiler

```ruby
class BeforeFilerProfiler < SpeedGun::Profiler::Base
  # `hook_method` is a helper of method profiling.
  hook_method ApplicationControler, :some_filter
end

class ApplicationControler
  def some_filer
    ...
  end
end
```

#### ForceGCProfiler

```ruby
class ForceGCProfiler < SpeedGun::Profiler::Base
  # You can define profiler type name.
  def self.type
    :force_gc_profiler
  end

  # `#before_profile` is called on before profiling.
  def before_profile
    @before_gc_disable = GC.enable
    GC.start
  end

  # `#after_profile` is called on after profiling.
  def after_profile
    GC.disable if @before_gc_disable
  end
end

SpeedGun.profile(:force_gc_profiler) { ... }
```

## Store

SpeedGun store request informations(profiling, environments and browser infos). You can select store engines.

### Built-in Stores

- `SpeedGun::Store::Memory` (default store engine on rack)
  - `max_entries` option: Set number of max profile entries(default: 100)
- `SpeedGun::Store::File` (default store engine on rails)
  - `path` option: Set stored path(default: `/tmp/speed_gun` or `Rails.root/tmp/speed_gun`)
  - `expires` option: Set expires in seconds(default: 1 day)
- `SpeedGun::Store::Memcache` (before `require 'speed_gun/store/memcache'`)
  - `client` option: Set memcache client instance(default: `Dalli::Clinet.new`)
  - `prefix` option: Set prefix of your profile key(default: `'speed-gun-'`)
  - `expires` option: Set expires in seconds(default: 1 day)
- `SpeedGun::Store::Redis` (before `require 'speed_gun/store/redis'`)
  - `client` option: Set redis client instance(default: `Redis.new`)
  - `prefix` option: Set prefix of your profile key(default: `'speed-gun-'`)
  - `expires` option: Set expires in seconds(default: 1 day)

### Custom Store

SpeedGun's store engines requires `[]` and `[]=` methods.

## Contributing

Please pull-requests :octocat: <http://github.com/rosylilly/speed_gun>
