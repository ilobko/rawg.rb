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

    def each
      i = 0
      loop do
        raise StopIteration if i == @count - 1

        if !@items[i] && @next_page_url
          response = @client.get(@next_page_url)
          from_api_response(response)
        end

        yield @items[i]
        i += 1
      end
    end

    def count(*args)
      return super if !args.empty? || block_given?

      @count
    end
  end
end
