# frozen_string_literal: true
require 'rails_helper'

describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user: user) }
  let!(:deck_card) { create(:expired_card, user: user, deck: deck) }

  context 'With active deck' do
    let!(:active_deck) { create(:active_deck, user: user) }

    context 'Card to check' do
      it 'returns a card from active deck' do
        active_deck_card = create(:expired_card, user: user, deck: active_deck)
        expect(user.card_to_check).to eq(active_deck_card)
      end
    end

    it 'returns active deck' do
      expect(user.active_deck).to eq(active_deck)
    end

    it 'returns all user decks' do
      expect(user.decks.count).to eq(2)
    end
  end

  it 'returns a card from deck' do
    expect(user.card_to_check).to eq(deck_card)
  end

  it 'sends an email about expired cards' do
    another_user = create(:user, email: 'test123@mail.com')
    create(:card, user: another_user,
           deck: create(:deck, user: another_user))

    expect {
      described_class.notify_about_expired_cards
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
