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

### Client

You should provide a user agent to identify your app.

```ruby
rawg = RAWG::Client.new(user_agent: 'MyAwesomeApp/1.0')
```

**Search games**

```ruby
rawg.games(search: 'gta')                       # => <RAWG::Collection>
rawg.games(search: 'zombie', genres: 'racing')  # => <RAWG::Collection>
```

**Fetch a game by slug of ID**

```ruby
rawg.game('fallout')
rawg.game(132026)
```

### Game

```ruby
minecraft = rawg.game('minecraft')
```

**Attributes**

```ruby
minecraft.id            # => 22509
minecraft.slug          # => "minecraft"
minecraft.name          # => "Minecraft"
minecraft.description   # => "<p>One of the most popular games of the 2010s...
minecraft.website       # => "https://minecraft.net"
minecraft.rating        # => 4.32
```

**Suggested games**

```ruby
minecraft.suggested
# => <RAWG::Collection>
```


### Simple Requests

These methods return API response as a hash. No pagination.

**All games**

```ruby
rawg.all_games(genres: 'indie')
```

**Search games**

```ruby
rawg.search_games('zombie', genres: 'racing')
```

**Search users**

```ruby
rawg.search_games(genres: 'indie')
```


## Contributing

Feel free to submit new issues at [github.com/ivanlobko/rawg.rb/issues](https://github.com/ivanlobko/rawg.rb/issues).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
