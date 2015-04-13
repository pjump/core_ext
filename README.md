# CoreExt

My collection of essential (and possibly nonessential) core extensions/mixins (mixins that are intended to
  be mixed into core classes).

I may add more as I need more, using RubyOnRail's ActiveSupport as my main source (hey, it's MIT licensed),

## Selection Strategy
My strategy for adding extensions is as follows:

  - if it can be a mixin, make it a mixin instead of modifying the core class directly
  - only essential stuff in the modules that map to to core classes

Each extension that takes the form of a mixin shall have the following form:

```ruby
  CoreExt::`TargetClassOrModule`
      #- contains the function version of the new functionality
  CoreExt::`TargetClassOrModule`::MethodVersions
      #- is intended to be `include`d into the `TargetClassOrModule`
```

#### Examples
##### (Module) Function version
```ruby
  CoreExt::String.camelize('string_argument') #=> 'StringArgument'
  CoreExt::String.undescore('StringArgument') #=> 'string_argument'
```

##### Method version
```ruby
  String.include(CoreExt::String::MethodVersions)

  'StringArgument'.underscore #=> 'string_argument'
 'string_argument'.camelize #=> 'StringArgument'
```
## Specialized Functionality
I either won't be adding specialized functionality (e.g., web-related stuff, linguistic functions) or such functionality will be separated into its own optional modules.

I may simplify some of the functionality as in the case of (e.g., my version of `camelize` IS the oppossite of underscore -- no special treatment for predefined acronyms) or expand it, if it fits my philosophy.

## Unincluding Mixins
  I highly recommend using the `uninclude` plugin. With it, you can for example, decorate your library's entry methods to include a mixin in to a core class before it starts and uniclude it at the end. That will allow you to use a modified core class in the context of your library without polluting the outside world.

## Executables
I might expose some functionality in the form of executables to support your UNIX workflow. Check out the `camelCase' and `snake_case` executables.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'core_ext'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install core_ext

## Usage

Use it in any way you like.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/core_xt/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Versioning
### Version Number for Machines

This gem uses a slightly modified version of the **SemVer** specification, namely:
```ruby
    spec.version = "BREAKING.PATCHES.NONBREAKING"
```
You can use this versioning with your dependency tools, only you have a somewhat stronger guarantee that your
code won't break if you limit yourself to the third number, but you need to allow second level updates in order to
get (security and other) patches.

### Version Number for Humans
Since the above-described type of versioning doesn't tell you anything about the functional state of the gem (you can go from a "hello world" to a full blown operating system
without making a breaking change, as long as your operating system prints "hello world" to the screen) (SemVer, when used correctly, doesn't tell anything about the functional state of a software package either), a second, human-friendly version number can be found in `spec.metadata[:human_version]`.

The magnitude of this version number shall be made to correspond to actual functional changes in the software. If I've worked a lot on the package, I'll make it move a lot, but unless I've made breaking changes, I'll stick to only moving the third number in the `spec.version` version.

This number is for you. If you see it increase a lot, it probably means much more new goodies, but is less strictly defined then the version number for the machine.  (I reserve the right to later change the way I change this number).

