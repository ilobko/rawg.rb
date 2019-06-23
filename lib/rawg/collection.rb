# frozen_string_literal: true

module RAWG
  class Collection
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

    def each(&block)
      @items.each(&block)
    end

    def count(*args)
      return super if !args.empty? || block_given?

      @count
    end

    private

    def fetch_next_page
      # response = @client.get(@next_page_url)
      # fetched_items = response[:results].map do |item|
      #   @items_class.new(client: @client).from_api_response(item)
      # end
      # @items.push(*fetched_items)
    end
  end
end
