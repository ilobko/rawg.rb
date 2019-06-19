# frozen_string_literal: true

module RAWG
  class Review
    include RAWG::Utils

    attr_accessor :id, :text

    def initialize(client = nil, **options)
      @client = client
      assign_attributes(options)
      yield self if block_given?
    end

    def game; end

    def user; end
  end
end
