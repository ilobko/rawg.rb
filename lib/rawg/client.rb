# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

module RAWG
  class Client
    DEFAULT_USER_AGENT  = "rawg-rb/#{RAWG::VERSION}"
    BASE_URL            = 'https://api.rawg.io'

    attr_reader :user_agent

    def initialize(user_agent: nil)
      @user_agent = build_user_agent(user_agent)
    end

    def get(*args)
      @http_client.get(*args).body
    end

    def all_games(options = {})
      request('/api/games', options)
    end

    def all_users(options = {})
      request('/api/users', options)
    end

    def search_games(query, options = {})
      all_games(search: query, **options)
    end

    def search_users(query, options = {})
      all_users(search: query, **options)
    end

    def game_info(game)
      request("/api/games/#{game}")
    end

    def game_suggest(game, options = {})
      request("/api/games/#{game}/suggested", options)
    end

    def game_reviews(game, options = {})
      request("/api/games/#{game}/reviews", options)
    end

    def user_info(user)
      request("/api/users/#{user}")
    end

    def user_games(user, options = {})
      request("/api/users/#{user}/games", options)
    end

    def user_reviews(user, options = {})
      request("/api/users/#{user}/reviews", options)
    end

    def game(game)
      response = game_info(game)
      RAWG::Game.new(client: self).from_response(response)
    end

    def games(options = {})
      response = all_games(options)
      RAWG::Collection.new(RAWG::Game, client: self).from_response(response)
    end

    def users(options = {})
      response = all_users(options)
      RAWG::Collection.new(RAWG::User, client: self).from_response(response)
    end

    def reviews(options = {})
      response = all_reviews(options)
      RAWG::Collection.new(RAWG::Review, client: self).from_response(response)
    end

    private

    def build_user_agent(user_agent)
      ua = user_agent&.to_s&.strip
      return DEFAULT_USER_AGENT if ua.nil? || ua.empty?

      [ua, DEFAULT_USER_AGENT].join(' ')
    end

    def http_client
      @http_client ||= Faraday.new(
        url: BASE_URL,
        headers: { user_agent: @user_agent, content_type: 'application/json' }
      ) do |conn|
        conn.response :json,
                      content_type: /\bjson$/,
                      parser_options: { symbolize_names: true }
        conn.adapter Faraday.default_adapter
      end
    end

    def request(path, options = {})
      query = format_query(options)
      response = http_client.get(path, query).body
      return nil unless response.is_a?(Hash)
      return nil if response[:detail] == 'Not found.'

      response
    end

    def format_query(options)
      options
        .map { |k, v| [k, serialize_query_value(v)] }
        .to_h
        .compact
    end

    def serialize_query_value(value)
      return value unless value.is_a? Array

      value.join(',')
    end
  end
end
