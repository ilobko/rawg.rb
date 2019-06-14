# frozen_string_literal: true

module RAWG
  class Game
    attr_accessor :id, :slug, :name, :description,
                  :released, :website, :rating

    def initialize
      yield self if block_given?
    end
  end
end
