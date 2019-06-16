# frozen_string_literal: true

require 'rawg'

rawg = RAWG::Client.new(user_agent: 'Game Finder', http_client: HTTParty.new, page_size: 40)

rawg.all_games(genres: 'indie')

# /api/games?search=gta
rawg.search_games('gta')
# /api/games?search=civ&genres=strategy
rawg.search_games('civ', genres: 'strategy')
rawg.search_users('anton')
rawg.search_developers('nintendo')

rawg.game(12343)
rawg.game('minecraft')
rawg.game_reviews('factorio')
rawg.game_suggest('minecraft')

rawg.user(1)
rawg.user('orels1')
# /api/users/orels1/games?statuses=owned
rawg.user_games('orels1', statuses: 'owned')
rawg.user_reviews('orels1')


# Users

# Get all users
rawg.users

# Get total number of users
rawg.users.count

# Search user by username, full_name, etc.
# /api/users?search={arg}
rawg.users.search('anton')
rawg.users.search('anton').count
rawg.users.search('anton').map(&:name)
rawg.users.search('anton').first

# Find user by id or username
# /api/users/<id or username>
rawg.users.find('orels1')
rawg.users.find(9)
rawg.users.find('orels1').games(statuses: :playing)
rawg.users.find('orels1').games.playing.first
rawg.users.find('orels1').games.with(statuses: 'playing').map(&:name)

# User's games
# /api/users/<id or username>/games
rawg.users.find(9).games # => Enumerator
rawg.users.find(9).games.to_a
rawg.users.find(9).games.count
rawg.users.find(9).games.first(100)

# User's reviews
# /api/users/<id or username>/reviews
rawg.users.find(9).reviews # => Enumerator
rawg.users.find(9).reviews.to_a
rawg.users.find(9).reviews.count
rawg.users.find(9).reviews.filter { |r| r.is_text == true }

rawg.users.find(9).followers.count

# Games

# /api/games?genres=strategy
rawg.games.with(genres: 'strategy').count

# Search games
# /api/games?search={param}
rawg.games.search('red')

# Find game by id or slug
rawg.games.find('factorio')

# Developers

# Search developers
rawg.developers.search('valve')

# Find developer
rawg.developers.find('valve-software')
rawg.developers.find('valve-software').top_games.first

# Collections
# Reviews
