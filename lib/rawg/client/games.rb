# frozen_string_literal: true

module RAWG
  class Client
    # Methods for Games API.
    module Games
      def all_games(options = {})
        get('/api/games', options)
      end

      def search_games(query, options = {})
        all_games(search: query, **options)
      end

      def game_info(game)
        get("/api/games/#{game}")
      end

      def game_suggest(game, options = {})
        get("/api/games/#{game}/suggested", options)
      end

      def game(game)
        response = game_info(game)
        RAWG::Game.new(client: self).from_api_response(response)
      end

      def games(options = {})
        response = all_games(options)
        RAWG::Paginator.new(RAWG::Game, client: self)
                       .from_api_response(response)
      end
    end
  end
end
