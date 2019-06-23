# frozen_string_literal: true

describe RAWG::Collection do
  it 'includes Enumerable' do
    expect(described_class).to be < Enumerable
  end

  describe '#initialize' do
    subject(:collection) { described_class.new(Object) }

    it 'uses items_class'

    context 'when client is specified' do
      it 'uses that client'
    end

    context 'when client is not specified' do
      it 'uses RAWG::Client.new'
    end
  end

  describe '#from_api_response' do
    it 'returns self'
    it 'sets @next_page_url'
    it 'sets @count'
    it 'appends @items'
  end

  describe '#each' do
  end

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
