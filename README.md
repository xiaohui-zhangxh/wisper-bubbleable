# Wisper::Bubbleable

A Wisper plugin to bubble events up to parent listener.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wisper-bubbleable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install wisper-bubbleable

## Usage

```ruby
class CoffeeStatePublisher
  include Wisper::Publisher
  include Wisper::Bubbleable

  def change(state)
    if state == true
      broadcast(:power_on, 'Power On')
    elsif state == false
      broadcast(:power_off, 'Power Off')
    else
      broadcast(:invalid_state, state)
    end
  end
end

class CoffeeMakerPublisher
  include Wisper::Publisher
  include Wisper::Bubbleable

  def power(on_or_off)
    state = CoffeeStatePublisher.new
    # ** bubble events here **
    state.bubble(:power_on, :power_off).to(self)
    state.on(:power_on) { broadcast(:warming) }
    state.on(:invalid_state) { |x| broadcast(:error, x) }
    state.change(on_or_off)
  end
end

class Listener
  def output(msg); puts msg; end
  alias power_on output
  alias power_off output
  def warming; puts 'Warming up...'; end
end

maker = CoffeeMakerPublisher.new and nil
maker.subscribe(Listener.new) and nil
maker.power(true) and nil
# => Power On
# => Warming up...
maker.power(false) and nil
# => Power Off
maker.power('boy') and nil
# => <No thing happen>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xiaohui-zhangxh/wisper-bubbleable.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
