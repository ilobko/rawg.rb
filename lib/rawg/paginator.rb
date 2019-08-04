# frozen_string_literal: true

module RAWG
  # A class that stores and handles a collection of items.
  class Paginator
    include Enumerable

    attr_reader :items_class, :client

    def initialize(klass, client: RAWG::Client.new)
      @items_class = klass
      @client = client
      @count = 0
      @items = []
      @next_page_url = nil
    end

    def from_api_response(response)
      @next_page_url = response[:next]
      @count = response[:count]
      response[:results].each do |attrs|
        new_item = @items_class.new(client: @client).from_api_response(attrs)
        @items.push(new_item)
      end
      self
    end

    def each(start = 0)
      return enum_for(:each, start) { @count }.lazy unless block_given?

      @items[start..-1].each do |item|
        yield item
      end

      return unless @next_page_url

      start = [@items.count, start].max
      fetch_next_page
      each(start, &Proc.new)
    end

    def count(item = nil)
      return super(item, &Proc.new) if item || block_given?

      @count
    end

    private

    def fetch_next_page
      return self unless @next_page_url

      response = @client.get(@next_page_url)
      from_api_response(response)
    end
  end
end
