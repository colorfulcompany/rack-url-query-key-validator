# Rack::UrlRepeatedStringValidator
A Rack middleware for exclude strings repeated in the URL, it will be bad requests.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "rack-url-repeated-string-validator"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-url-repeated-string-validator


## Usage

### Rails app

```ruby
# invalid_keys default: ["amp;"]
# max_allowed default: 3
# logger default: nil
config.middleware.use Rack::UrlRepeatedStringValidator, invalid_keys: ["foo"], max_repeated: 3, logger: Rails.logger
```

for example...
* OK => `http://localhost?foofoofoo=bar`
* NG => `http://localhost?foofoofoofoo=bar`

### Rack App

```ruby
Rack::Builder.new do
  use Rack::UrlRepeatedStringValidator, invalid_keys: ["foo"], max_repeated: 3, logger: logger
  run Rack::Application
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

