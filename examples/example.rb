# frozen_string_literal: true

require 'rawg'

rawg = RAWG::Client.new(user_agent: 'Game Finder', page_size: 40)

rawg.all_games(genres: 'indie')                                   # Done

# Searches
# /api/games?search=gta
rawg.search_games('gta')                                          # Done
# /api/games?search=civ&genres=strategy
rawg.search_games('civ', genres: 'strategy')                      # Done
# /api/games?search=zombie&genres=racing,sports
rawg.search_games('zombie', genres: ['racing','sports'])          # Done
rawg.search_users('anton')                                        # Done
# rawg.search_developers('nintendo')                              # Skip

# Games
rawg.game(12343)                                                  # Done
rawg.game('minecraft')                                            # Done
rawg.game_suggest('minecraft')                                    # Done
rawg.game_reviews('factorio')                                     # Done

rawg.games.count                                                  # 
rawg.games(genres: 'racing').count                                # 
rawg
  .games(genres: 'racing')
  .count { |g| g.name.contains('zombie') }                        # 
rawg.games(search: 'zombie', genres: 'racing').count              # 
rawg.users(1)
  .games(search: 'rally', statuses: 'playing')
  .map { |g| g.stores.contains?(:steam) }                         # 



# Users
rawg.user(1)                                                      # Done
rawg.user('orels1')                                               # Done
rawg.user_games('orels1')                                         # Done
# /api/users/orels1/games?statuses=owned
rawg.user_games('orels1', statuses: 'owned')                      # Done
rawg.user_reviews('orels1')                                       # Done
# rawg.user_followers('orels1')                                   # Skip
# rawg.user_collections('orels1')                                 # Skip






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
rawg.users.find('orels1').games(statuses: 'playing')
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


rawg.games # => Enumerator
rawg.games # => Games
rawg.games.select { |g| g.genres.include?(Genre.new(:racing)) }
rawg.games.search('bla bla') # => Games
rawg.games.search('bla bla'). # => Games



# Проблема
# Мы хотим посчитать все игры с жанром 'racing'
# Нижеследующая строка скачает все игры и посчитает жанры в Руби:
rawg.games.count { |g| g.genres.include?(:racing) }
# А нужно, чтобы клиент сделал запрос /api/games?genres=racing и вернул response[:count]:
rawg.all_games(genres: 'racing')[:count]
# Может сделать так? Вроде так более очевидно, где мы управляем запросом, а где кодим на Руби
rawg.games(genres: 'racing').count
# Проверим на других примерах:
rawg.games.count
rawg.games(genres: 'racing').count { |g| g.name.contains('zombie') } # пагинация, работает Руби
rawg.games(search: 'zombie', genres: 'racing').count # работает запрос
rawg.users(1).games(search: 'rally', statuses: 'playing').map { |g| g.stores.contains?(:steam) }
rawg.games('factorio')



# Developers

# Search developers
rawg.developers.search('valve')

# Find developer
rawg.developers.find('valve-software')
rawg.developers.find('valve-software').top_games.first