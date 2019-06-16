# frozen_string_literal: true

require 'pry'

class Game
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def foo
    puts "#{name} foo"
  end
end

class Games
  include Enumerable

  def initialize(games, count: nil)
    @games = games
    @count = count
  end

  def each
    @games.each do |game|
      yield game
    end
  end

  def count
    @count || super
  end
end

binding.pry
