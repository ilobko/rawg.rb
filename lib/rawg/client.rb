# frozen_string_literal: true

require 'faraday'

module RAWG
  class Client
    GEM_NAME        = 'rawg-rb'
    GEM_VERSION     = '0.1'
    GEM_USER_AGENT  = "#{GEM_NAME}/#{GEM_VERSION}"
    BASE_URL = 'https://api.rawg.io'

    attr_reader :user_agent

    def initialize(user_agent: nil, http_client: Faraday)
      @user_agent = build_user_agent(user_agent)
      @http_client = http_client.new(
        url: BASE_URL,
        headers: { user_agent: @user_agent, content_type: 'application/json' }
      )
    end

    def find_game(id)
      @http_client.get("/api/games/#{id}")
    end

    private

    def build_user_agent(user_agent)
      ua = user_agent&.to_s&.strip
      return GEM_USER_AGENT if ua.nil? || ua.empty?

      [ua, GEM_USER_AGENT].join(' ')
    end
  end
end
