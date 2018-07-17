# authorization-endpoint-ruby

**A Ruby gem for discovering a URL’s [authorization endpoint](https://indieweb.org/authorization-endpoint) for use with [Micropub](https://indieweb.org/Micropub) and [IndieAuth](https://indieweb.org/IndieAuth) clients.**

[![Gem](https://img.shields.io/gem/v/authorization-endpoint.svg?style=for-the-badge)](https://rubygems.org/gems/authorization-endpoint)
[![Downloads](https://img.shields.io/gem/dt/authorization-endpoint.svg?style=for-the-badge)](https://rubygems.org/gems/authorization-endpoint)
[![Build](https://img.shields.io/travis/com/jgarber623/authorization-endpoint-ruby/master.svg?style=for-the-badge)](https://travis-ci.com/jgarber623/authorization-endpoint-ruby)
[![Dependencies](https://img.shields.io/depfu/jgarber623/authorization-endpoint-ruby.svg?style=for-the-badge)](https://depfu.com/github/jgarber623/authorization-endpoint-ruby)
[![Maintainability](https://img.shields.io/codeclimate/maintainability/jgarber623/authorization-endpoint-ruby.svg?style=for-the-badge)](https://codeclimate.com/github/jgarber623/authorization-endpoint-ruby)
[![Coverage](https://img.shields.io/codeclimate/c/jgarber623/authorization-endpoint-ruby.svg?style=for-the-badge)](https://codeclimate.com/github/jgarber623/authorization-endpoint-ruby/code)

## Key Features

- Uses the same discovery algorithm outlined in [Section 5.3](https://www.w3.org/TR/micropub/#endpoint-discovery) of [the W3C's Micropub Recommendation](https://www.w3.org/TR/micropub/).
- Supports Ruby 2.4 and newer.

## Getting Started

Before installing and using authorization-endpoint-ruby, you'll want to have [Ruby](https://www.ruby-lang.org) 2.4 (or newer) installed. It's recommended that you use a Ruby version managment tool like [rbenv](https://github.com/rbenv/rbenv), [chruby](https://github.com/postmodern/chruby), or [rvm](https://github.com/rvm/rvm).

authorization-endpoint-ruby is developed using Ruby 2.4.4 and is additionally tested against Ruby 2.5.1 using [Travis CI](https://travis-ci.com/jgarber623/authorization-endpoint-ruby).

## Installation

If you're using [Bundler](https://bundler.io), add authorization-endpoint-ruby to your project's `Gemfile`:

```ruby
source 'https://rubygems.org'

gem 'authorization-endpoint'
```

…and hop over to your command prompt and run…

```sh
$ bundle install
```

## Usage

### Basic Usage

With authorization-endpoint-ruby added to your project's `Gemfile` and installed, you may discover a URL's authorization endpoint by doing:

```ruby
require 'authorization-endpoint'

endpoint = AuthorizationEndpoint.discover('https://aaronparecki.com')

puts endpoint # returns String: 'https://aaronparecki.com/auth'
```

This example will search `https://aaronparecki.com` for a valid authorization endpoint using the same rules described in [the W3C's Micropub Recommendation](https://www.w3.org/TR/micropub/#endpoint-discovery). In this case, the program returns a string: `https://aaronparecki.com/auth`.

If no endpoint is discovered at the provided URL, the program will return `nil`:

```ruby
require 'authorization-endpoint'

endpoint = AuthorizationEndpoint.discover('https://example.com')

puts endpoint.nil? # returns Boolean: true
```

### Advanced Usage

Should the need arise, you may work directly with the `AuthorizationEndpoint::Client` class:

```ruby
require 'authorization-endpoint'

client = AuthorizationEndpoint::Client.new('https://aaronparecki.com')

puts client.response # returns HTTP::Response
puts client.endpoint # returns String: 'https://aaronparecki.com/auth'
```

### Exception Handling

There are several exceptions that may be raised by authorization-endpoint-ruby's underlying dependencies. These errors are raised as subclasses of `AuthorizationEndpoint::Error` (which itself is a subclass of `StandardError`).

From [jgarber623/absolutely](https://github.com/jgarber623/absolutely) and  [sporkmonger/addressable](https://github.com/sporkmonger/addressable):

- `AuthorizationEndpoint::InvalidURIError`

From [httprb/http](https://github.com/httprb/http):

- `AuthorizationEndpoint::ConnectionError`
- `AuthorizationEndpoint::TimeoutError`
- `AuthorizationEndpoint::TooManyRedirectsError`

## Contributing

Interested in helping improve authorization-endpoint-ruby? Awesome! Your help is greatly appreciated. See [CONTRIBUTING.md](https://github.com/jgarber623/authorization-endpoint-ruby/blob/master/CONTRIBUTING.md) for details.

## Acknowledgments

authorization-endpoint-ruby wouldn't exist without Micropub and the hard work put in by everyone involved in the [IndieWeb](https://indieweb.org) movement.

authorization-endpoint-ruby is written and maintained by [Jason Garber](https://sixtwothree.org).

## License

authorization-endpoint-ruby is freely available under the [MIT License](https://opensource.org/licenses/MIT). Use it, learn from it, fork it, improve it, change it, tailor it to your needs.
