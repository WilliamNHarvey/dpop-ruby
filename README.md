# Dpop

Implementation of DPoP ([Demonstrating Proof-of-Possession at the Application Layer](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-dpop)) for Ruby and Rails apps.

Adds a 

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add dpop

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install dpop

## Usage

In general, this gem provides two concepts: A wrapper for creating private keys that this gem can consume, and an API for consuming those private keys to generate Proof JWT's for a given request.

### Setup

This gem uses a configuration concept for setup, and then can be accessed through module methods on `Dpop`

Run the configurer to set with defaults:
```ruby
Dpop.configure
```

Or pass a block to overwrite defaults:
```ruby
Dpop.configure do |config|
  config.encryption_key = MY_SECURE_SECRET_PASSPHRASE
end
```

|Configurable variable|Description|Default value|
|===|===|===|
|cookie_name|Cookie saved on the browser when using the Rails controller concern|"_proof_keys"|
|encryption_key|Secure passphrase used for encrypting cookes with Rails|ENV["DPOP_ENCRYPTION_KEY"]|
|generated_key_size|Byte size of generated private keys|1024|


### Module methods

To generate a consumable private key, run `Dpop.generate_key_pair`. That will return a PEM string, which can be used with openssl by running `OpenSSL::PKey::RSA.new(key)`

To generate a Proof JWT, run `Dpop.get_proof_with_key(key, htu: "https://www.website.call/path", htm: "GET"`. That will return a JWT string, which should be added to the Dpop header of your http request.

### Rails

In Rails apps, this gem automatically configures on initialization using a Railtie. At any time, those configuration variables can be overwritten manually as described above, but running `Dpop.configure` to initialize the gem isn't mandatory.

The app provides a controller concern that can be used to ensure user's browsers have a private key saved in their cookies, which can be relied on to prove possession of their browser. A proof can then be generated using that key, to be attached to your HTTP requests.

In your `ApplicationController`, add `include Dpop::Controller`.

In your controllers where you'd like to ensure your user has a key set, or in your `ApplicationController`, add `ensure_dpop!`

When you want to create a proof signed with that key, use `get_proof(htu: "https://www.website.call/path", htm: "GET")`

Example using `Net::HTTP`:
```
class MyController < ApplicationController
  ensure_dpop!

  def index
    uri = URI("https://www.myresourcehost.com/index?page=1")
    proof = get_proof(htu: dpop_htu(uri), htm: "GET")

    req = Net::HTTP::Get.new(uri)
    req['authorization'] = "DPoP #{my_access_token}"
    req['dpop'] = proof

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    @data = res.body
  end

  def create
    uri = URI("https://www.myresourcehost.com/index?page=1")
    proof = get_proof(htu: dpop_htu(uri), htm: "GET")

    req = Net::HTTP::Post.new(uri)
    req['authorization'] = "DPoP #{my_access_token}"
    req['dpop'] = proof

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    @data = res.body
  end

  private

  # Only pass scheme, host, and path following DPoP spec
  def dpop_htu(uri)
    uri.fragment = dpop_uri.query = nil
    uri
  end

end
```

## Development

`bundle install` to setup. Develop using `bundle console` for ruby, or by installing the gem through `path:` in your consuming app.

To release a new version, update the version number in `version.rb`, run `bundle install` to update Gemfile.lock, and add a CHANGELOG.md entry for your version.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/WilliamNHarvey/dpop-ruby. Please add clear testing instructions in your PR.

## License

[Apache Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
