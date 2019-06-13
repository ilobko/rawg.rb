# frozen_string_literal: true

module RAWG
  class Client
    VERSION = '0.1'

    def initialize(user_agent: "rawgrb/#{VERSION}")
      @user_agent = user_agent
    end
  end
end
