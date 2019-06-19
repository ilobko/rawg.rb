# RAWG.rb

This is an unofficial Ruby client for [RAWG.io](https://rawg.io) API. RAWG is the largest video game database and game discovery service. See rules and more information at [rawg.io/apidocs](https://rawg.io/apidocs).


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

Feel free to create GitHub issues at https://github.com/ivanlobko/rawg.rb.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
