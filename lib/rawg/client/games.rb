# frozen_string_literal: true

module RAWG
  class Client
    # Methods for Games API.
    module Games
      # Get all games
      #
      # @param [String] genres
      #
      # @return [Hash]
      #
      # @example
      #   rawg.all_games(genres: 'indie')
      def all_games(options = {})
        get('/api/games', options)
      end

      # Find games that match given search query
      #
      # @return [Hash]
      #
      # @example
      #   rawg.search_games('zombie', genres: 'racing')
      def search_games(query, options = {})
        all_games(search: query, **options)
      end

      # Get game details
      #
      # @return [Hash]
      def game_info(game)
        get("/api/games/#{game}")
      end

      # @return [Hash]
      def game_suggest(game, options = {})
        get("/api/games/#{game}/suggested", options)
      end

      # @return [RAWG::Game]
      def game(game)
        response = game_info(game)
        RAWG::Game.new(client: self).from_api_response(response)
      end

      # @return [RAWG::Paginator]
      def games(options = {})
        response = all_games(options)
        RAWG::Paginator.new(RAWG::Game, client: self)
                       .from_api_response(response)
      end
    end
  end
end
