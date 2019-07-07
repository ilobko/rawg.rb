# frozen_string_literal: true

describe RAWG::Client do
  subject(:client) { described_class.new }

  it 'has BASE_URL = \'https://api.rawg.io\'' do
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

  describe '#game_reviews' do
    it_behaves_like 'a request',
                    subject: -> { described_class.new.game_reviews('factorio') },
                    method: :get,
                    endpoint: '/api/games/factorio/reviews',
                    successful_response: fixture('game_reviews_response.json')

    it_behaves_like 'a paginator',
                    subject: described_class.new,
                    method_name: :game_reviews,
                    method_args: 'factorio',
                    endpoint: '/api/games/factorio/reviews'

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

    it_behaves_like 'a paginator',
                    subject: described_class.new,
                    method_name: :user_games,
                    method_args: 1,
                    method_options: { statuses: 'owned' },
                    endpoint: '/api/users/1/games?statuses=owned'

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

    it_behaves_like 'a paginator',
                    subject: described_class.new,
                    method_name: :user_reviews,
                    method_args: 1,
                    endpoint: '/api/users/1/reviews'

    it 'returns results array' do
      stub_get('/api/users/1/reviews',
               fixture: 'user_reviews_response.json')
      response = client.user_reviews(1)
      expect(response[:results]).to be_an Array
    end
  end
end
