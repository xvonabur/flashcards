# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Deck, type: :model do
  let!(:user) { create(:user) }
  let!(:active_deck) { create(:active_deck, user: user) }

  it 'sets active status for deck on create' do
    2.times { create(:deck, user: user) }

    expect(user.active_deck).to eq(active_deck)
  end
end
