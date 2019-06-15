# frozen_string_literal: true

require 'spec_helper'

describe RAWG::Client do
  it 'has constant BASE_URL' do
    expect(described_class::BASE_URL).to eq('https://api.rawg.io')
  end

  describe '#initialize' do
    it 'uses its own user agent if no agent provided' do
      expect(described_class.new.user_agent).to eq(RAWG::Client::GEM_USER_AGENT)
    end

    it 'appends its own user agent to provided agent' do
      test_user_agent = 'TestUserAgent/1.0'
      client = described_class.new(user_agent: test_user_agent)
      expect(client.user_agent)
        .to eq("#{test_user_agent} #{RAWG::Client::GEM_USER_AGENT}")
    end

    it 'strips provided user agent from whitespaces' do
      test_user_agent = '     TestUserAgent/1.0     '
      client = described_class.new(user_agent: test_user_agent)
      expect(client.user_agent)
        .to eq("#{test_user_agent.strip} #{RAWG::Client::GEM_USER_AGENT}")
    end
  end

  describe '#find_game' do
    subject(:client) { described_class.new }

    it 'requests correct endpoint' do
      stub_get('/api/games/22509').to_return(status: 200)
      client.find_game(22_509)
      expect(a_get('/api/games/22509')).to have_been_made.once
    end

    context 'when game exists' do
      it 'returns hash with symbolized keys'
      it 'returns requested game'
    end

    context 'when game doesn\'t exist' do
      it 'returns nil'
    end
  end
end
