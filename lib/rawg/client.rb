# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'rawg/client/games'

module RAWG
  class Client
    include RAWG::Client::Games

    DEFAULT_USER_AGENT = "rawg.rb/#{RAWG::VERSION}"
    BASE_URL           = 'https://api.rawg.io'

    attr_reader :user_agent

    def initialize(user_agent: nil)
      @user_agent = combine_user_agents(user_agent, DEFAULT_USER_AGENT)
      @http_client = default_http_client
    end

    def get(path, query = {})
      response = @http_client.get(path, format_query(query)).body
      return nil unless response.is_a?(Hash)
      return nil if response[:detail] == 'Not found.'

      response
    end

    def all_users(options = {})
      get('/api/users', options)
    end

    def search_users(query, options = {})
      all_users(search: query, **options)
    end

    def game_reviews(game, options = {})
      get("/api/games/#{game}/reviews", options)
    end

    def user_info(user)
      get("/api/users/#{user}")
    end

    def user_games(user, options = {})
      get("/api/users/#{user}/games", options)
    end

    def user_reviews(user, options = {})
      get("/api/users/#{user}/reviews", options)
    end

    private

    def combine_user_agents(*user_agents)
      user_agents.join(' ').squeeze(' ').strip
    end

    def default_http_client
      Faraday.new(
        url: BASE_URL,
        headers: { user_agent: @user_agent, content_type: 'application/json' }
      ) do |conn|
        conn.response :json, content_type: /\bjson$/,
                             parser_options: { symbolize_names: true }
        conn.adapter Faraday.default_adapter
      end
    end

    def format_query(query)
      query
        .map { |field, value| [field, serialize_query_value(value)] }
        .to_h
        .compact
    end

    def serialize_query_value(value)
      return value unless value.is_a? Array

      value.join(',')
    end
  end
end
