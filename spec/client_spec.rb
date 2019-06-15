# frozen_string_literal: true

require 'helper'

describe RAWG::Client do
  describe '#initialize' do
    it 'uses its own user agent if no agent provided' do
      expect(subject.user_agent).to eq(RAWG::Client::GEM_USER_AGENT)
    end

    it 'appends its own user agent to provided agent' do
      test_user_agent = 'TestUserAgent/1.0'
      client = RAWG::Client.new(user_agent: test_user_agent)
      expect(client.user_agent)
        .to eq("#{test_user_agent} #{RAWG::Client::GEM_USER_AGENT}")
    end

    it 'strips provided user agent from whitespaces' do
      test_user_agent = '     TestUserAgent/1.0     '
      client = RAWG::Client.new(user_agent: test_user_agent)
      expect(client.user_agent)
        .to eq("#{test_user_agent.strip} #{RAWG::Client::GEM_USER_AGENT}")
    end
  end
end
