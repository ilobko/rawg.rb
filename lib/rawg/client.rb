# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'pry'

module RAWG
  class Client
    VERSION             = '0.1'
    DEFAULT_USER_AGENT  = "rawg-rb/#{VERSION}"
    BASE_URL            = 'https://api.rawg.io'

    attr_reader :user_agent

    def initialize(user_agent: nil)
      @user_agent = build_user_agent(user_agent)
    end

    def search_games(query, genres: nil)
      request('/api/games', {
        search: query,
        genres: genres.is_a?(Array) ? genres.join(',') : genres
      }.compact)
    end

    def search_users(query)
      request('/api/users', search: query)
    end

    def game_info(game)
      request("/api/games/#{game}")
    end

    def game_suggest(game)
      request("/api/games/#{game}/suggested")
    end

    def user_info(user)
      request("/api/users/#{user}")
    end

    def user_games(user, statuses: nil)
      request("/api/users/#{user}/games", {
        statuses: statuses.is_a?(Array) ? statuses.join(',') : statuses
      }.compact)
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

    def request(path, query = {})
      response = http_client.get(path, query).body
      return nil unless response.is_a?(Hash)
      return nil if response[:detail] == 'Not found.'

      response
    end
  end
end
