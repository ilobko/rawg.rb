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

# These examples verify that provided mehod:
# - uses provided endpoint
# - uses provided http method
# - sends User-Agent header
# - parses response into Hash with symbolized keys
# - handles unexpected response body
shared_examples 'a request' do |options|
  url                 = RAWG::Client::BASE_URL + options[:endpoint]
  method              = options[:method]
  subject             = options[:subject]
  successful_response = options[:successful_response]
  not_found_response  = options[:not_found_response]

  it 'sends correct User-Agent header' do
    stub_request(:any, /.*/).to_return(status: 200)
    subject.call
    expect(a_request(:any, /.*/)
      .with(headers: { 'User-Agent': client.user_agent }))
      .to have_been_made
  end

  it 'requests correct endpoint' do
    stub_request(:any, /.*/).to_return(status: 200)
    subject.call
    expect(a_request(method, url)).to have_been_made.once
  end

  context 'when found', if: successful_response do
    before do
      stub_request(:any, /.*/).to_return(
        body: successful_response,
        headers: { content_type: 'application/json' }
      )
    end

    it 'returns hash' do
      response = subject.call
      expect(response).to be_a(Hash)
    end

    it 'returns hash with symbolized keys' do
      response = subject.call
      expect(response.keys).to all be_a(Symbol)
    end
  end

  context 'when not found', if: not_found_response do
    before do
      stub_request(:any, /.*/).to_return(
        body: not_found_response,
        headers: { content_type: 'application/json' }
      )
    end

    it 'returns nil' do
      response = subject.call
      expect(response).to be_nil
    end
  end

  context 'when unexpected response' do
    before do
      stub_request(:any, /.*/).to_return(
        body: 'gibberish',
        headers: { content_type: 'text/plain' }
      )
    end

    it 'returns nil' do
      response = subject.call
      expect(response).to be_nil
    end
  end
end

# These examples verify that provided mehod:
# - appends page=<number> to query
# - appends page_size=<size> to query
shared_examples 'a paginator' do |options|
  subject        = options[:subject]
  method_name    = options[:method_name]
  method_args    = options[:method_args]
  method_options = options[:method_options] || {}
  url            = RAWG::Client::BASE_URL + options[:endpoint]
  http_method    = options[:http_method] || :get

  before { stub_request(:any, /.*/).to_return(status: 200) }

  it 'sends page size' do
    subject.public_send(method_name, *method_args, page_size: 40, **method_options)
    expect(a_request(http_method, url)
      .with(query: { page_size: 40 }))
      .to have_been_made
  end

  it 'sends page number' do
    subject.public_send(method_name, *method_args, page: 2, **method_options)
    expect(a_request(http_method, url)
      .with(query: { page: 2 }))
      .to have_been_made
  end
end
