# frozen_string_literal: true

describe RAWG::Client do
  subject(:client) { described_class.new }

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
end
