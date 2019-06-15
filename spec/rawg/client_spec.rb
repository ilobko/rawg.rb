# frozen_string_literal: true

require 'spec_helper'

describe RAWG::Client do
  it 'has correct BASE_URL' do
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

  describe '#game_info' do
    subject(:client) { described_class.new }

    it 'requests correct endpoint' do
      stub_get('/api/games/22509').to_return(status: 200)
      client.game_info(22_509)
      expect(a_get('/api/games/22509')).to have_been_made.once
    end

    it 'sends correct User-Agent header' do
      stub_get('/api/games/22509').to_return(status: 200)
      client.game_info(22_509)
      expect(a_get('/api/games/22509')
        .with(headers: { 'User-Agent': client.user_agent }))
        .to have_been_made
    end

    context 'when game exists' do
      before do
        stub_get('/api/games/22509').to_return(
          body: fixture('game_info_response.json'),
          headers: { content_type: 'application/json' }
        )
      end

      it 'returns hash' do
        response = client.game_info(22_509)
        expect(response).to be_a(Hash)
      end

      it 'returns hash with symbolized keys' do
        response = client.game_info(22_509)
        expect(response.keys).to all be_a(Symbol)
      end

      it 'returns requested game' do
        response = client.game_info(22_509)
        expect(response[:id]).to be_eql(22_509)
      end
    end

    context 'when game doesn\'t exist' do
      before do
        stub_get('/api/games/0').to_return(
          body: fixture('game_not_found_response.json'),
          headers: { content_type: 'application/json' }
        )
      end

      it 'returns nil' do
        response = client.game_info(0)
        expect(response).to be_nil
      end
    end
  end

  describe '#user_info' do
    subject(:client) { described_class.new }

    it 'requests correct endpoint' do
      stub_get('/api/users/1').to_return(status: 200)
      client.user_info(1)
      expect(a_get('/api/users/1')).to have_been_made.once
    end

    it 'sends correct User-Agent header' do
      stub_get('/api/users/1').to_return(status: 200)
      client.user_info(1)
      expect(a_get('/api/users/1')
        .with(headers: { 'User-Agent': client.user_agent }))
        .to have_been_made
    end

    context 'when user exists' do
      before do
        stub_get('/api/users/1').to_return(
          body: fixture('user_info_response.json'),
          headers: { content_type: 'application/json' }
        )
      end

      it 'returns hash' do
        response = client.user_info(1)
        expect(response).to be_a(Hash)
      end

      it 'returns hash with symbolized keys' do
        response = client.user_info(1)
        expect(response.keys).to all be_a(Symbol)
      end

      it 'returns requested game' do
        response = client.user_info(1)
        expect(response[:id]).to be_eql(1)
      end
    end

    context 'when user doesn\'t exist' do
      before do
        stub_get('/api/users/0').to_return(
          body: fixture('game_not_found_response.json'),
          headers: { content_type: 'application/json' }
        )
      end

      it 'returns nil' do
        response = client.user_info(0)
        expect(response).to be_nil
      end
    end
  end
end
