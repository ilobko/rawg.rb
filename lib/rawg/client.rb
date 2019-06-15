# frozen_string_literal: true

module RAWG
  class Client
    GEM_NAME        = 'rawgrb'
    GEM_VERSION     = '0.1'
    GEM_USER_AGENT  = "#{GEM_NAME}/#{GEM_VERSION}"

    attr_reader :user_agent

    def initialize(user_agent: nil)
      @user_agent = build_user_agent(user_agent)
    end

    private

    def build_user_agent(user_agent)
      ua = user_agent&.to_s&.strip
      return GEM_USER_AGENT if ua.nil? || ua.empty?

      [ua, GEM_USER_AGENT].join(' ')
    end
  end
end
