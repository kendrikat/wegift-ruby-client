# WeGift Ruby Client

A simple client for [WeGift.io][wegift] B2B Synchronous API (Document Version 1.2). 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wegift-ruby-client'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install wegift-ruby-client
```

## Usage

Simple example for ordering a Digital Card
```ruby
# a simple client 
client = Wegift::Client.new(
      :api_host => 'http://sandbox.wegift.io',
      :api_path => '/api/b2b-sync/v1/auth'
      :api_key => ENV['AUTH_NAME'],
      :api_secret => ENV['AUTH_PASS']
)

# and a simple request
order = Wegift::Order.new(
        :product_code => 'tTV',
        :delivery => 'direct',
        :amount => '42.00',
        :currency_code => 'USD',
        :external_ref => '123'
)

# executes the POST (TODO: shared/singleton client?)
order.post(client) 

# and returns
if order.is_successful?

  # some nice data
  order.code
  order.pin
  order.expiry_date
  
end
```

_See official docs for Product Codes (http://sandbox.wegift.io/product-codes)_

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Testing

Run it!
```bash
rspec
```

It will load all tapes found in `spec/tapes`, we are using [VCR][vcr].

Optional - If you want/need to remaster all the recordings, you will need a sandbox account. 
Add an `.env` file to your root:

```bash
# .env
AUTH_NAME='sandbox_username'
AUTH_PASS='sandbox_password'
```

Start the VCR with `rspec` - this should add all Tapes to `spec/tapes`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kendrikat/wegift-ruby-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[wegift]: http://WeGift.io
[vcr]: https://github.com/vcr/vcr