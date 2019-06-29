# 💎 RAWG.rb

This is a Ruby client for RAWG API.

[RAWG.io](https://rawg.io) is the largest video game database and game discovery service. See [rawg.io/apidocs](https://rawg.io/apidocs) for rules and additional information about the API.


## Installation

Add this line to your Gemfile:

```ruby
gem 'rawg_rb'
```    

Or install manually:

    $ gem install rawg_rb


## Usage

```ruby
# You should provide a user agent to identify your app.
rawg = RAWG::Client.new(user_agent: 'MyAwesomeApp/1.0')

# Fetch a game by slug or id
rawg.game('fallout')
rawg.game(132026)

minecraft = rawg.game('minecraft') # => <RAWG::Game>
minecraft.id           # => 22509
minecraft.slug         # => "minecraft"
minecraft.name         # => "Minecraft"
minecraft.description  # => "<p>One of the most popular games of the 2010s...
minecraft.website      # => "https://minecraft.net"
minecraft.rating       # => 4.32

# Find similar games
games_like_minecraft = minecraft.suggested     # => <RAWG::Collection>

# Collection is Enumerable.
# If the result contains multiple pages, additional pages will be requested if needed.
games_like_minecraft.first(2).map(&:name)  # => ['Project Explore', 'Planet Nomads']

# Search games
rawg.games(search: 'gta')                      # => <RAWG::Collection>
rawg.games(search: 'zombie', genres: 'racing') # => <RAWG::Collection>

```


### Simple Requests

These methods return a hash containing API response as it is.

```ruby
rawg.all_games(genres: 'indie')
rawg.search_games('zombie', genres: 'racing')
rawg.search_games(genres: 'indie')
rawg.game_info(132026)
rawg.game_suggest('minecraft')
```


## Contributing

Feel free to submit new issues at [github.com/ivanlobko/rawg.rb/issues](https://github.com/ivanlobko/rawg.rb/issues).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
