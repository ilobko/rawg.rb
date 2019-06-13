# frozen_string_literal: true

require 'helper'

describe RAWG::Client do
  describe '#initialize' do
    context 'when user agent provided' do
      test_user_agent = 'Test User Agent'
      subject { RAWG::Client.new(user_agent: test_user_agent) }

      it 'sets user agent' do
        expect(subject.user_agent).to eq(test_user_agent)
      end
    end
    context 'when user agent not provided' do
      it 'sets default user agent' do
        expect(subject.user_agent).to eq(RAWG::Client::DEFAULT_USER_AGENT)
      end
    end
  end
end
