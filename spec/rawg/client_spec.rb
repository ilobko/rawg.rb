# frozen_string_literal: true

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

# These examples verify that provided mehod:
# - appends page=<number> to query
# - appends page_size=<size> to query
shared_examples 'a paginator' do |options|
  subject        = options[:subject]
  method_name    = options[:method_name]
  method_args    = options[:method_args]
  method_options = options[:method_options] || {}
  url            = RAWG::Client::BASE_URL + options[:endpoint]
  http_method    = options[:http_method] || :get

  before { stub_request(:any, /.*/).to_return(status: 200) }

  it 'sends page size' do
    subject.public_send(method_name, *method_args, page_size: 40, **method_options)
    expect(a_request(http_method, url)
      .with(query: { page_size: 40 }))
      .to have_been_made
  end

  it 'sends page number' do
    subject.public_send(method_name, *method_args, page: 2, **method_options)
    expect(a_request(http_method, url)
      .with(query: { page: 2 }))
      .to have_been_made
  end
end

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

  describe '#all_games' do
    before { stub_request(:any, /.*/).to_return(status: :ok) }

    it_behaves_like 'a request',
                    subject: -> { described_class.new.all_games(genres: 'indie') },
                    method: :get,
                    endpoint: '/api/games?genres=indie',
                    successful_response: fixture('all_games_response.json')

    it_behaves_like 'a paginator',
                    subject: described_class.new,
                    method_name: :all_games,
                    method_options: { genres: 'indie' },
                    endpoint: '/api/games?genres=indie'

    it 'returns games using single genre' do
      client.all_games(genres: 'strategy')
      expect(a_get('/api/games?genres=strategy')).to have_been_made
    end

    it 'returns games using multiple genres' do
      client.all_games(genres: %w[racing sports])
      expect(a_get('/api/games?genres=racing,sports')).to have_been_made
    end
  end

  describe '#search_games' do
    before { stub_request(:any, /.*/).to_return(status: :ok) }

    it_behaves_like 'a request',
                    subject: -> { described_class.new.search_games('gta') },
                    method: :get,
                    endpoint: '/api/games?search=gta',
                    successful_response: fixture('search_games_response.json')

    it_behaves_like 'a paginator',
                    subject: described_class.new,
                    method_name: :search_games,
                    method_args: 'gta',
                    endpoint: '/api/games?search=gta'

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

    it_behaves_like 'a paginator',
                    subject: described_class.new,
                    method_name: :search_users,
                    method_args: 'Alexey Gornostaev',
                    endpoint: '/api/users?search=Alexey%20Gornostaev'

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

    it_behaves_like 'a paginator',
                    subject: described_class.new,
                    method_name: :game_suggest,
                    method_args: 22_509,
                    endpoint: '/api/games/22509/suggested'

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
