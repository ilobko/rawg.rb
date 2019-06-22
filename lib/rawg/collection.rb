# frozen_string_literal: true

module RAWG
  class Collection
    include Enumerable

    attr_reader :items_class, :items

    def initialize(klass, client: RAWG::Client.new)
      @items_class = klass
      @client = client
      @count = 0
      @items = []
      @next_page_url = nil
    end

    def from_response(response)
      @next_page_url = response[:next]
      @count = response[:count]
      @items = response[:results].map do |attrs|
        items_class.new(client: @client).from_response(attrs)
      end
      self
    end

    def each(&block)
      @items.each(&block)
    end

    def count(*args)
      return super if !args.empty? || block_given?

      @count
    end

    private

    def fetch_next_page
      response = client.get(@next_page_url)
      @items << response[:results].map do |item|
        items_class.new(client: @client).from_response(item)
      end
    end

    def client
      @client ||= RAWG::Client.new
    end
  end
end
