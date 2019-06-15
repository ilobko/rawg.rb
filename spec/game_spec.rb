# frozen_string_literal: true

require 'spec_helper'

describe RAWG::Game do
  subject { FactoryBot.build(:game) }

  it { is_expected.to have_attr_accessor(:id) }
  it { is_expected.to have_attr_accessor(:slug) }
  it { is_expected.to have_attr_accessor(:name) }
  it { is_expected.to have_attr_accessor(:description) }
  it { is_expected.to have_attr_accessor(:released) }
  it { is_expected.to have_attr_accessor(:website) }
  it { is_expected.to have_attr_accessor(:rating) }
  it 'yields itself' do
    yielded_instance = nil
    new_instance = described_class.new { |i| yielded_instance = i }
    expect(yielded_instance).to be new_instance
  end
end
