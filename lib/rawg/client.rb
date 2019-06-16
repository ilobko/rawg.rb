# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'pry'

module RAWG
  class Client
    GEM_NAME        = 'rawg-rb'
    GEM_VERSION     = '0.1'
    GEM_USER_AGENT  = "#{GEM_NAME}/#{GEM_VERSION}"
    BASE_URL        = 'https://api.rawg.io'

    attr_reader :user_agent

    def initialize(user_agent: nil)
      @user_agent = build_user_agent(user_agent)
    end

    def search_games(search, genres: nil)
      request('/api/games', {
        search: search,
        genres: genres.is_a?(Array) ? genres.join(',') : genres
      }.compact)
    end

    def search_users(search)
      request('/api/users', search: search)
    end

    def game_info(id)
      request("/api/games/#{id}")
    end

    def game_suggest(id)
      request("/api/games/#{id}/suggested")
    end

    def user_info(id)
      request("/api/users/#{id}")
    end

    def user_games(id, statuses: nil)
      request("/api/users/#{id}/games", {
        statuses: statuses.is_a?(Array) ? statuses.join(',') : statuses
      }.compact)
    end

    private

    def build_user_agent(user_agent)
      ua = user_agent&.to_s&.strip
      return GEM_USER_AGENT if ua.nil? || ua.empty?

      [ua, GEM_USER_AGENT].join(' ')
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
