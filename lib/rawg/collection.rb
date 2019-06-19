# frozen_string_literal: true

module RAWG
  class Collection
    include Enumerable

    attr_reader :items_class

    def initialize(klass, options)
      @items_class = klass
      @client = options[:client]
    end

    def from_response(response)
      @next_page_url = response[:next]
      @count = response[:count]
      @items = response[:results].map do |attrs|
        items_class.new(client: @client, **attrs)
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

    def fetch_next_page
      response = client.get(next_page_url)
      games << response[:results].map { |params| Game.new(params) }
    end

    def client
      @client ||= RAWG::Client.new
    end
  end
end
