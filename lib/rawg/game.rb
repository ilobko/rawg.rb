# frozen_string_literal: true

require_relative './utils'

module RAWG
  # Representation of a game.
  #
  # @!attribute [r] id
  #   @return [Integer] the id of the game
  # @!attribute slug
  #   @return [String] the slug of the game
  class Game
    include RAWG::Utils

    lazy_attr_accessor :id, :slug, :name, :description,
                       :released, :website, :rating,
                       init: ->(_) { assign_attributes(@client.game_info(@id)) }

    def initialize(options = {})
      @client = options[:client] || RAWG::Client.new
      assign_attributes(options)
      yield self if block_given?
    end

    def from_api_response(response)
      assign_attributes(response)
      self
    end

    def suggested(options = {})
      response = @client.game_suggest(@id, options)
      RAWG::Paginator
        .new(RAWG::Game, client: @client)
        .from_api_response(response)
    end

    attr_reader :client
  end
end
