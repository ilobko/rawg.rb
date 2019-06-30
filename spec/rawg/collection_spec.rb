# frozen_string_literal: true

describe RAWG::Collection do
  it 'includes Enumerable' do
    expect(described_class).to be < Enumerable
  end

  describe '#initialize' do
    subject(:collection) { described_class.new(given_items_class, **options) }
    
    let(:given_items_class) { Class.new }
    let(:options) { {} }

    it 'uses items_class' do
      expect(collection.items_class).to eq given_items_class
    end

    context 'when client is specified' do
      let(:specific_client) { RAWG::Client.new }
      let(:options) { { client: specific_client } }

      it 'uses that client' do
        expect(collection.client).to be(specific_client)
      end
    end

    context 'when client is not specified' do
      it 'uses RAWG::Client.new' do
        expect(collection.client).to be_an_instance_of(RAWG::Client)
      end
    end
  end

  describe '#from_api_response' do
    it 'returns self'
    it 'sets @next_page_url'
    it 'sets @count'
    it 'appends @items'
  end

  describe '#each'

  describe '#count' do
    it 'returns the number of items'
    it 'does not enumerate through items'

    context 'when an argument is given' do
      it 'enumerates through items'
      it 'returns the number of items that are equal to the argument'
    end

    context 'when a block is given' do
      it 'enumerates through items'
      it 'returns the number of items yielding a true value'
    end
  end
end
