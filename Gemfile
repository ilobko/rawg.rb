# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

group :development do
  gem 'rubocop', '~> 0.72', require: false
  gem 'rubocop-performance', '~> 1.4', require: false
  gem 'rubocop-rspec', '~> 1.33', require: false
end

group :test do
  gem 'coveralls', '~> 0.8', require: false
  gem 'faker', '~> 2.1'
  gem 'simplecov', '~> 0.16', require: false
end

gemspec
