# frozen_string_literal: true
require 'rails_helper'

describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user: user) }
  let!(:active_deck) { create(:deck, user: user, active: true) }

  context 'Card to check' do
    let!(:deck_card) { create(:expired_card, user: user, deck: deck) }

    it 'returns a card from active deck' do
      active_deck_card = create(:expired_card, user: user, deck: active_deck)
      expect(user.card_to_check).to eq(active_deck_card)
    end

    it 'returns a card from deck' do
      expect(user.card_to_check).to eq(deck_card)
    end
  end
end
