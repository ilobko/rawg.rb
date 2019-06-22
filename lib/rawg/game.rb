# frozen_string_literal: true

require_relative './utils'

module RAWG
  class Game
    include RAWG::Utils

    lazy_attr_accessor :id, :slug, :name, :description,
                       :released, :website, :rating,
                       init: ->(_) { @client.game_info(@id) }

    def initialize(options = {})
      @client = options[:client] || RAWG::Client.new
      assign_attributes(options)
      yield self if block_given?
    end

    def from_response(response)
      assign_attributes(response)
      self
    end

    def suggested(options)
      response = client.game_suggest(@id, options)
      RAWG::Collection.new(RAWG::Game, client: client).from_response(response)
    end

    def reviews(options)
      response = client.game_reviews(@id, options)
      RAWG::Collection.new(RAWG::Review, client: client).from_response(response)
    end
  end
end
