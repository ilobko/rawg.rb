# frozen_string_literal: true

require 'spec_helper'

shared_examples 'a request' do |request|
  it 'sends correct User-Agent header' do
    stub_request(:any, /.*/).to_return(status: 200)
    request.call
    expect(a_request(:any, /.*/)
      .with(headers: { 'User-Agent': client.user_agent }))
      .to have_been_made
  end

  context 'when found' do
    before do
      stub_request(:any, /.*/).to_return(
        body: fixture('user_info_response.json'),
        headers: { content_type: 'application/json' }
      )
    end

    it 'returns hash' do
      response = request.call
      expect(response).to be_a(Hash)
    end

    it 'returns hash with symbolized keys' do
      response = request.call
      expect(response.keys).to all be_a(Symbol)
    end
  end

  context 'when not found' do
    before do
      stub_request(:any, /.*/).to_return(
        body: fixture('not_found_response.json'),
        headers: { content_type: 'application/json' }
      )
    end

    it 'returns nil' do
      response = request.call
      expect(response).to be_nil
    end
  end

  context 'when unexpected response' do
    before do
      stub_request(:any, /.*/).to_return(
        body: 'gibberish',
        headers: { content_type: 'text/plain' }
      )
    end

    it 'returns nil' do
      response = request.call
      expect(response).to be_nil
    end
  end
end

describe RAWG::Client do
  subject(:client) { described_class.new }

  it 'has correct BASE_URL' do
    expect(described_class::BASE_URL).to eq('https://api.rawg.io')
  end

  describe '#initialize' do
    it 'uses its own user agent if no agent provided' do
      expect(described_class.new.user_agent).to eq(RAWG::Client::GEM_USER_AGENT)
    end

    it 'appends its own user agent to provided agent' do
      test_user_agent = 'TestUserAgent/1.0'
      client_with_agent = described_class.new(user_agent: test_user_agent)
      expect(client_with_agent.user_agent)
        .to eq("#{test_user_agent} #{RAWG::Client::GEM_USER_AGENT}")
    end

    it 'strips provided user agent from whitespaces' do
      test_user_agent = '     TestUserAgent/1.0     '
      client_with_agent = described_class.new(user_agent: test_user_agent)
      expect(client_with_agent.user_agent)
        .to eq("#{test_user_agent.strip} #{RAWG::Client::GEM_USER_AGENT}")
    end
  end

  describe '#game_info' do
    it_behaves_like 'a request', -> { described_class.new.game_info(22_509) }

    it 'requests correct endpoint' do
      stub_get('/api/games/22509').to_return(status: 200)
      client.game_info(22_509)
      expect(a_get('/api/games/22509')).to have_been_made.once
    end

    it 'returns requested game' do
      stub_get('/api/games/22509', fixture: 'game_info_response.json')
      response = client.game_info(22_509)
      expect(response[:id]).to be_eql(22_509)
    end
  end

  describe '#user_info' do
    it_behaves_like 'a request', -> { described_class.new.user_info(1) }
    it 'requests correct endpoint' do
      stub_get('/api/users/1').to_return(status: 200)
      client.user_info(1)
      expect(a_get('/api/users/1')).to have_been_made.once
    end
    it 'returns requested user' do
      stub_get('/api/users/1', fixture: 'user_info_response.json')
      response = client.user_info(1)
      expect(response[:id]).to be_eql(1)
    end
  end
end
