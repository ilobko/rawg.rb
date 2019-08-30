# frozen_string_literal: true

describe RAWG::Client::Users do
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
