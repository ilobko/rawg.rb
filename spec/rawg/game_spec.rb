# frozen_string_literal: true

describe RAWG::Game do
  subject { FactoryBot.build(:game) }

  it { is_expected.to have_attr_accessor(:id) }
  it { is_expected.to have_attr_accessor(:slug) }
  it { is_expected.to have_attr_accessor(:name) }
  it { is_expected.to have_attr_accessor(:description) }
  it { is_expected.to have_attr_accessor(:released) }
  it { is_expected.to have_attr_accessor(:website) }
  it { is_expected.to have_attr_accessor(:rating) }

  describe '#initialize' do
    context 'when client is specified' do
      it 'uses that client'
    end

    context 'when client is not specified' do
      it 'uses RAWG::Client.new'
    end

    context 'when block given' do
      it 'yields itself' do
        yielded_instance = nil
        new_instance = described_class.new { |i| yielded_instance = i }
        expect(yielded_instance).to be new_instance
      end
    end
  end

  describe '#from_api_response' do
    it 'returns self'
    it 'assigns attributes from response'
  end

  describe '#suggested' do
    subject(:game) do
      described_class.new(id: 22_509)
    end

    before do
      stub_get('/api/games/22509/suggested',
               fixture: 'game_suggest_response.json')
    end

    it 'makes a single request to /games/<id>/suggested' do
      game.suggested
      expect(a_get('/api/games/22509/suggested'))
        .to have_been_made.once
    end

    it 'returns a collection of games' do
      result = game.suggested
      expect(result).to be_a RAWG::Collection
    end
  end
end
