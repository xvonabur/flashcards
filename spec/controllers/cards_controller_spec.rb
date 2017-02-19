# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  context 'Guest runs forbidden operations' do
    let!(:user) { create(:user) }
    let!(:card) { create(:card, user: user, deck: create(:deck, user: user)) }
    let!(:new_original) { 'New original' }

    it 'does not change a card after trying to update it' do
      put(:update, params: { id: card.id, card: { original_text: new_original } })
      expect(card.reload.original_text).to_not eq(new_original)
    end

    it 'does not remove a card after trying to remove it' do
      delete(:destroy, params: { id: card.id })
      expect(card.reload).to eq(card)
    end
  end

  context 'User manipulates her card data' do
    let!(:user) { create(:user) }
    let!(:card) { create(:card, user: user, deck: create(:deck, user: user)) }
    let!(:new_card_attrs) do
      { original_text: 'New original text', translated_text: 'New translated text' }
    end

    before { login_user user }

    it 'changes card attrs successfully' do
      put(:update, params: { id: card.id, card: new_card_attrs })

      expect(card.reload.original_text).to eq(new_card_attrs[:original_text])
    end

    it 'changes card attrs successfully' do
      delete(:destroy, params: { id: card.id })

      expect(Card.where(id: card.id).first).to eq(nil)
    end
  end

  context 'User manipulates not owned card data' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user, email: 'abc@mail.com') }
    let!(:card) do
      create(:card, user: another_user, deck: create(:deck, user: another_user))
    end

    let!(:new_card_attrs) do
      { original_text: 'New original text', translated_text: 'New translated text' }
    end

    before { login_user user }

    it 'changes card attrs unsuccessfully' do
      put(:update, params: { id: card.id, card: new_card_attrs })

      expect(card.reload.original_text).to_not eq(new_card_attrs[:original_text])
    end

    it 'changes card attrs unsuccessfully' do
      delete(:destroy, params: { id: card.id })

      expect(Card.where(id: card.id).first).to eq(card)
    end
  end
end
