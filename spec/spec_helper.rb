# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
if ENV['CI']
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'spec_config'

def a_get(path)
  a_request(:get, RAWG::Client::BASE_URL + path)
end

def stub_get(path, fixture: nil)
  return stub_request(:get, RAWG::Client::BASE_URL + path) unless fixture

  stub_request(:get, RAWG::Client::BASE_URL + path)
    .to_return(
      body: fixture(fixture),
      headers: { content_type: 'application/json' }
    )
end

def fixture_path
  File.expand_path('fixtures', __dir__)
end

def fixture(file)
  File.new(fixture_path + '/' + file).read
end
