# frozen_string_literal: true

require 'spec_helper'

# These examples verify that provided mehod:
# - uses provided endpoint
# - uses provided http method
# - sends User-Agent header
# - parses response into Hash with symbolized keys
# - handles unexpected response body
shared_examples 'a request' do |options|
  url                 = RAWG::Client::BASE_URL + options[:endpoint]
  method              = options[:method]
  subject             = options[:subject]
  successful_response = options[:successful_response]
  not_found_response  = options[:not_found_response]

  it 'sends correct User-Agent header' do
    stub_request(:any, /.*/).to_return(status: 200)
    subject.call
    expect(a_request(:any, /.*/)
      .with(headers: { 'User-Agent': client.user_agent }))
      .to have_been_made
  end

  it 'requests correct endpoint' do
    stub_request(:any, /.*/).to_return(status: 200)
    subject.call
    expect(a_request(method, url)).to have_been_made.once
  end

  context 'when found', if: successful_response do
    before do
      stub_request(:any, /.*/).to_return(
        body: successful_response,
        headers: { content_type: 'application/json' }
      )
    end

    it 'returns hash' do
      response = subject.call
      expect(response).to be_a(Hash)
    end

    it 'returns hash with symbolized keys' do
      response = subject.call
      expect(response.keys).to all be_a(Symbol)
    end
  end

  context 'when not found', if: not_found_response do
    before do
      stub_request(:any, /.*/).to_return(
        body: not_found_response,
        headers: { content_type: 'application/json' }
      )
    end

    it 'returns nil' do
      response = subject.call
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
      response = subject.call
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
      expect(described_class.new.user_agent).to eq(RAWG::Client::DEFAULT_USER_AGENT)
    end

    it 'appends its own user agent to provided agent' do
      test_user_agent = 'TestUserAgent/1.0'
      client_with_agent = described_class.new(user_agent: test_user_agent)
      expect(client_with_agent.user_agent)
        .to eq("#{test_user_agent} #{RAWG::Client::DEFAULT_USER_AGENT}")
    end

    it 'strips provided user agent from whitespaces' do
      test_user_agent = '     TestUserAgent/1.0     '
      client_with_agent = described_class.new(user_agent: test_user_agent)
      expect(client_with_agent.user_agent)
        .to eq("#{test_user_agent.strip} #{RAWG::Client::DEFAULT_USER_AGENT}")
    end
  end

  describe '#search_games' do
    before { stub_request(:any, /.*/).to_return(status: :ok) }

    it_behaves_like 'a request',
                    subject: -> { described_class.new.search_games('gta') },
                    method: :get,
                    endpoint: '/api/games?search=gta',
                    successful_response: fixture('search_games_response.json')

    it 'searches games without parameters' do
      client.search_games('gta')
      expect(a_get('/api/games?search=gta')).to have_been_made
    end

    it 'searches games using single genre' do
      client.search_games('tank', genres: 'strategy')
      expect(a_get('/api/games?search=tank&genres=strategy')).to have_been_made
    end

    it 'searches games using multiple genres' do
      client.search_games('zombie', genres: %w[racing sports])
      expect(a_get('/api/games?search=zombie&genres=racing,sports'))
        .to have_been_made
    end
  end

  describe '#search_users' do
    before { stub_request(:any, /.*/).to_return(status: :ok) }

    it_behaves_like 'a request',
                    subject: -> { described_class.new.search_users('Alexey Gornostaev') },
                    method: :get,
                    endpoint: '/api/users?search=Alexey%20Gornostaev',
                    successful_response: fixture('search_users_response.json')

    it 'searches users' do
      client.search_users('Alexey Gornostaev')
      expect(a_get('/api/users?search=Alexey%20Gornostaev')).to have_been_made
    end
  end

  describe '#game_info' do
    it_behaves_like 'a request',
                    subject: -> { described_class.new.game_info(22_509) },
                    method: :get,
                    endpoint: '/api/games/22509',
                    successful_response: fixture('game_info_response.json'),
                    not_found_response: fixture('not_found_response.json')

    it 'returns requested game' do
      stub_get('/api/games/22509', fixture: 'game_info_response.json')
      response = client.game_info(22_509)
      expect(response[:id]).to be_eql(22_509)
    end
  end

  describe '#game_suggest' do
    it_behaves_like 'a request',
                    subject: -> { described_class.new.game_suggest(22_509) },
                    method: :get,
                    endpoint: '/api/games/22509/suggested',
                    successful_response: fixture('game_suggest_response.json')

    it 'returns results array' do
      stub_get('/api/games/22509/suggested',
               fixture: 'game_suggest_response.json')
      response = client.game_suggest(22_509)
      expect(response[:results]).to be_an Array
    end
  end

  describe '#game_reviews' do
    it_behaves_like 'a request',
                    subject: -> { described_class.new.game_reviews('factorio') },
                    method: :get,
                    endpoint: '/api/games/factorio/reviews',
                    successful_response: fixture('game_reviews_response.json')

    it 'returns results array' do
      stub_get('/api/games/factorio/reviews',
               fixture: 'game_reviews_response.json')
      response = client.game_reviews('factorio')
      expect(response[:results]).to be_an Array
    end
  end

  describe '#user_info' do
    it_behaves_like 'a request',
                    subject: -> { described_class.new.user_info(1) },
                    method: :get,
                    endpoint: '/api/users/1',
                    successful_response: fixture('user_info_response.json'),
                    not_found_response: fixture('not_found_response.json')

    it 'returns requested user' do
      stub_get('/api/users/1', fixture: 'user_info_response.json')
      response = client.user_info(1)
      expect(response[:id]).to be_eql(1)
    end
  end

  describe '#user_games' do
    it_behaves_like 'a request',
                    subject: -> { described_class.new.user_games(1) },
                    method: :get,
                    endpoint: '/api/users/1/games',
                    successful_response: fixture('user_games_response.json')

    it 'returns results array' do
      stub_get('/api/users/1/games',
               fixture: 'user_games_response.json')
      response = client.user_games(1)
      expect(response[:results]).to be_an Array
    end

    it 'returns games using single status' do
      stub_get('/api/users/1/games?statuses=owned').to_return(status: :ok)
      client.user_games(1, statuses: 'owned')
      expect(a_get('/api/users/1/games?statuses=owned')).to have_been_made
    end

    it 'returns games using multiple statuses' do
      stub_get('/api/users/1/games?statuses=owned,playing').to_return(status: :ok)
      client.user_games(1, statuses: %w[owned playing])
      expect(a_get('/api/users/1/games?statuses=owned,playing')).to have_been_made
    end
  end

  describe '#user_reviews' do
    it_behaves_like 'a request',
                    subject: -> { described_class.new.user_reviews(1) },
                    method: :get,
                    endpoint: '/api/users/1/reviews',
                    successful_response: fixture('user_reviews_response.json')

    it 'returns results array' do
      stub_get('/api/users/1/reviews',
               fixture: 'user_reviews_response.json')
      response = client.user_reviews(1)
      expect(response[:results]).to be_an Array
    end
  end
end
