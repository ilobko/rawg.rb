# frozen_string_literal: true

FactoryBot.define do
  factory :game, class: RAWG::Game do
    id { |n| n }
    slug { Faker::Internet.slug }
    name { Faker::App.name }
    description { Faker::Lorem.paragraph }
    released { Faker::Date.backward(1000) }
    website { Faker::Internet.domain_name }
    rating { rand(0.0...5.0).round(2) }
  end
end
