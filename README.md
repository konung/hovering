# Hovering

Hovering is client gem to connect to Hover.com api to help read / update domain records. There is no official API support from Hover.com yet. This gem is piggybacking of the Hover's control_panel, which is really great. But sometimes you need to be able to update 50 nameserver records to point to new hosting - this when Hovering could help. Use at your own risk :-)

This was also an experiment to use parts of excellent [Trailblazer Framework](http://trb.to) outside of the context a web framework.

Thanks to [David Davis](https://github.com/daviddavis) and his [hover gem](https://github.com/daviddavis/hover). I used it as a starting point to explore Hover.com's API :-)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hovering'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install hovering
```

## Usage

**Basic API Usage**


Connecting to Hover.com
```ruby
@client = Hovering::Client.new(username: "GendalfTheGrey",
                               password: 'Annon edhellen, edro hi ammen.')
```

Create a reusable Faraday connection after authenticating. It's a simple Faraday::Connection object and can be manipulated accordingly

```ruby
@client.connection #=> #<Faraday::Connection:0x00007fbf0f181750....
```
Default `get` will make a call to `https://www.hover.com/api/domains`. You can specify a different endpoint
```ruby
@client.connection&.get('dns')
```

For your convenience several get methods are provided directly through the Hovering::Client object

```ruby
@client.all_domains
@client.all_dns
@client.all_forwards
@client.all_mailboxes
```

## Support
If you run across a bug or want to submit a patch - they are always welcome and appreciated. If anybody has good ideas on how to test against a live Hover api, I would love any suggestions. Hover doesn't provide a test API :-(

## GEM / API Limitations
This gem can be used to retrieve and update basic DNS records of the domains you already purchased. It doesn't support buying new / transferring existing domains or manipulating mailboxes, other than getting a list of them. That is because Hover.com doesn't expose that functionality over API.

However you can update such things as A, CNAME, MX, etc records, and some properties of the domains, which is very useful once you have more than 5-10 domains to manage.

I don't use Mailboxes feature of Hover.com - so any help testing / developing that is appreciated. Right now gem just provides a basic read functionality for that feature.

## Author
Questions & success stories? Drop me a line. Nick Gorbikoff on Twitter:  [@gorbikoff](https://twitter.com/gorbikoff)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/konung/hovering. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Be nice. Be respectful. Or else.

## Disclaimer of Warranties and Limitation of Liability.

Unless otherwise separately undertaken by the Licensor, to the extent possible, the Licensor offers the Licensed Material as-is and as-available, and makes no representations or warranties of any kind concerning the Licensed Material, whether express, implied, statutory, or other. This includes, without limitation, warranties of title, merchantability, fitness for a particular purpose, non-infringement, absence of latent or other defects, accuracy, or the presence or absence of errors, whether or not known or discoverable. Where disclaimers of warranties are not allowed in full or in part, this disclaimer may not apply to You.

To the extent possible, in no event will the Licensor be liable to You on any legal theory (including, without limitation, negligence) or otherwise for any direct, special, indirect, incidental, consequential, punitive, exemplary, or other losses, costs, expenses, or damages arising out of this Public License or use of the Licensed Material, even if the Licensor has been advised of the possibility of such losses, costs, expenses, or damages. Where a limitation of liability is not allowed in full or in part, this limitation may not apply to You.

The disclaimer of warranties and limitation of liability provided above shall be interpreted in a manner that, to the extent possible, most closely approximates an absolute disclaimer and waiver of all liability.

## Copyright

Copyright 2017, Nick Gorbikoff
