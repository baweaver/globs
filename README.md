# Globs

Expands glob-like strings into array sets.

If you've ever seen a string like this:

```ruby
"hostname.{west, east, north}.{100..150}.com"
```

...and wished that there were a way to have that expand to all 153 urls without
having to type out a bunch of arbitrarily deep map statements this gem is for you.

Why is this handy? If you have to type out a whole load of AWS names this can
be a lot nicer to type and iterate over to perform actions.

## Usage

### Sets

A set is defined as a set of comma delimited items inside brackets:

```ruby
"{1, 2, 3}"
```

In Globs, this would expand to the array `[1, 2, 3]`. The difference is if there
happen to be multiple globs present it will expand those items:

```ruby
Globs.expand("test.{a, b}.{1, 2}.com")
=> ["test.a.1.com", "test.a.2.com", "test.b.1.com", "test.b.2.com"]
```

These sets can be as long or as short as you would like.

### Ranges

Use inclusive (`..`) ranges to shorten consecutive elements in a Globs string:

```ruby
Globs.expand("test.{a..e}.com")
=> ["test.a.com", "test.b.com", "test.c.com", "test.d.com", "test.e.com"]
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'globs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install globs

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/baweaver/globs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Globs project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/baweaver/globs/blob/master/CODE_OF_CONDUCT.md).
