# frozen_string_literal: true

module RAWG
  class Client
    VERSION = '0.1'
    DEFAULT_USER_AGENT = "rawgrb/#{VERSION}"

    attr_accessor :user_agent

    def initialize(user_agent: DEFAULT_USER_AGENT)
      @user_agent = user_agent
    end
  end
end
