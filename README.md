# PciProxy

A simple client library for [PCI Proxy](https://pci-proxy.com)'s API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pci_proxy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pci_proxy

## Usage

Initially, this gem only covers the [Token API](https://docs.pci-proxy.com/collect-and-store-cards/capture-iframes/token-api), which converts a transactionId from the [secure fields](https://docs.pci-proxy.com/collect-and-store-cards/capture-iframes) mechanism into tokenised card PAN and CVV.

Pull requests are most welcome for coverage of other PCI Proxy APIs :)
### Token API - Usage

Create an instance of ```PciProxy::Token``` and call ```execute``` as follows:
```ruby
client = PciProxy::Token.new(api_username: 'username', api_password: 'password')
client.execute(transaction_id: '1234567890')

=> {"aliasCC"=>"411111GGCMUJ1111", "aliasCVV"=>"vCslSwP0SQ9JXJy-nDzLKHaS"}
```

In the event of a 200 OK response, the JSON response body is returned as a hash. In the event of an error, a subclass of ```PciProxyAPIError``` will be raised.

## Changes
See [Changelog](CHANGELOG.md)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/asmallworldsite/pci_proxy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
