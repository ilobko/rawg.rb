# 💎 RAWG.rb

This is a Ruby client for RAWG API.

[RAWG.io](https://rawg.io) is the largest video game database and game discovery service. See [rawg.io/apidocs](https://rawg.io/apidocs) for rules and additional information about the API.


## Installation

Add this line to your Gemfile:

```ruby
gem 'rawg'
```    

Or install manually:

    $ gem install rawg


## Usage

```ruby
rawg = RAWG::Client.new(user_agent: 'MyAwesomeApp/1.0')

zombie_racing_games = rawg.games(search: 'zombie', genres: 'racing')
```


## Contributing

Feel free to submit new issues at [github.com/ivanlobko/rawg.rb/issues](https://github.com/ivanlobko/rawg.rb/issues).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
