require 'rails_helper'

RSpec.describe Deck, type: :model do
  let!(:user) { create(:user) }
  let!(:active_deck) { create(:active_deck, user: user) }

  it 'sets active status for deck on create' do
    2.times { create(:deck, user: user) }

    expect(user.active_deck).to eq(active_deck)
  end

  context 'active deck' do
    let!(:deck) { deck = create(:deck, user: user) }

    before { deck.update(active: true) }

    it 'changes active deck after update' do
      expect(deck.user.active_deck).to eq(deck)
    end
  end
end
