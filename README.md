# PciProxy

A simple client library for [PCI Proxy](https://pci-proxy.com)'s API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pci_proxy', '~> 1.0.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pci_proxy

## Usage

Initially, this gem only covers the [Token API](https://docs.pci-proxy.com/collect-and-store-cards/capture-iframes/token-api), which converts a transactionId from the [secure fields](https://docs.pci-proxy.com/collect-and-store-cards/capture-iframes) mechanism into tokenised card PAN and CVV, and the [Check API](https://docs.pci-proxy.com/use-stored-cards/check) which allows verification of a card token.

Pull requests are most welcome for coverage of other PCI Proxy APIs :)
### Token API - Usage

Create an instance of ```PciProxy::Token``` and call ```execute``` as follows:
```ruby
client = PciProxy::Token.new(api_username: 'username', api_password: 'password')
```

And execute a token exchange like so:
```ruby
client.execute(transaction_id: '1234567890')
```

In the event of a 200 OK response, an instance of PciProxy::Model::TokenisedCard is returned:

```ruby
#<PciProxy::Model::TokenisedCard:0x00007fda073453f8 @pan_token="411111GGCMUJ1111", @cvv_token="b8XeAbhQQES6OVWTpOCaAscj", @type_slug=:visa>
```
(```response``` attr_reader value omitted for clarity)

This object has attr_readers for ```pan_token```, ```cvv_token``` and ```type_slug``` which will return one of the following symbols:

```ruby
[:visa, :mastercard, :amex, :diners, :discovery, :jcb, :elo, :cup, :unknown]
```

It also has an attr_reader for ```response``` which is the raw parsed JSON response, as a hash.

In the event of an error, a subclass of ```PciProxyAPIError``` will be raised.

The most likely error is that the transactionId temporary token has expired, resulting in:

```
PciProxy::BadRequestError (HTTP status: 400, Response: Tokenization not found)
```

### Check API - Usage

Create an instance of ```PciProxy::Check``` and call ```execute``` as follows:

```ruby
client = PciProxy::Check.new(api_username: 'username', api_password: 'password')
```

And execute a card verification like so:

```ruby
client.execute(reference: 'foo', card_token: '411111GGCMUJ1111', card_type: :visa, expiry_month: 1, expiry_year: 2022)
```

In all cases (success, denoted by 200 OK from the API, or error, denoted by non-200 response), an instance of ```PciProxy::Model::CheckResult``` is returned.

This object has attr_readers for ```auth_code```, ```transaction_id```, ```status``` and ```error```

It also has an attr_reader for ```response``` which is the raw parsed JSON response, as a hash.

With a successful response, the object's ```status``` attribute will have the value ```:success```, and the ```auth_code``` and ```transaction_id``` values will be available:
```ruby
#<PciProxy::Model::CheckResult:0x00007fbda2186fe8 @auth_code="124101", @transaction_id="190828124101219812", @error=nil, @status=:success>
```
(```response``` attr_reader value omitted for clarity)

With an unsuccessful response, the object's ```status``` attribute will have the value ```:error```:
```ruby
#<PciProxy::Model::CheckResult:0x00007fbda2186fe8 @auth_code=nil, @transaction_id=nil, @error={"code"=>"UNAUTHORIZED", "message"=>"The account is not configured to use this API."}, @status=:error>
```
(```response``` attr_reader value omitted for clarity)

## Changes
See [Changelog](CHANGELOG.md)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/asmallworldsite/pci_proxy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
