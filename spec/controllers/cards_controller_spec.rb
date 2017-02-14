# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  context 'Guest runs forbidden operations' do
    let!(:card) { create(:card) }
    let!(:new_original) { 'New original' }

    it 'redirects to root url for unsuccessful operation' do
      post(:create, params: {
        card: { original_text: new_original, translated_text: new_original }
      })
      expect(response).to redirect_to(root_url)
    end

    it 'does not create a card for unsuccessful operation' do
      expect {
        post(:create, params: { card: { original_text: '', translated_text: '' } })
      }.to_not change { Card.count }
    end

    it 'redirects to root url after trying to update a card' do
      put(:update, params: { id: card.id, card: { original_text: new_original } })
      expect(response).to redirect_to(root_url)
    end

    it 'does not change a card after trying to update her' do
      put(:update, params: { id: card.id, card: { original_text: new_original } })
      expect(card.reload.original_text).to_not eq(new_original)
    end

    it 'redirects to root url after trying to delete a card' do
      delete(:destroy, params: { id: card.id })
      expect(response).to redirect_to(root_url)
    end

    it 'does not remove a card after trying to remove her' do
      delete(:destroy, params: { id: card.id })
      expect(card.reload).to eq(card)
    end
  end

  context 'User manipulates her card data' do
    let!(:user) { create(:user) }
    let!(:card) { create(:card, user: user) }
    let!(:new_card_attrs) do
      { original_text: 'New original text', translated_text: 'New translated text' }
    end

    before { login_user user }

    it 'redirects to card page after successful update' do
      put(:update, params: { id: card.id, card: new_card_attrs })

      expect(response).to redirect_to(card_path(card.id))
    end

    it 'changes card attrs successfully' do
      put(:update, params: { id: card.id, card: new_card_attrs })

      expect(card.reload.original_text).to eq(new_card_attrs[:original_text])
    end

    it 'redirects to cards path after successful destroy' do
      delete(:destroy, params: { id: card.id })

      expect(response).to redirect_to(cards_path)
    end

    it 'changes card attrs successfully' do
      delete(:destroy, params: { id: card.id })

      expect(Card.where(id: card.id).first).to eq(nil)
    end
  end

  context 'User manipulates not owned card data' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user, email: 'abc@mail.com') }
    let!(:card) { create(:card, user: another_user) }
    let!(:new_card_attrs) do
      { original_text: 'New original text', translated_text: 'New translated text' }
    end

    before { login_user user }

    it 'redirects to cards page after unsuccessful update' do
      put(:update, params: { id: card.id, card: new_card_attrs })

      expect(response).to redirect_to(cards_path)
    end

    it 'changes card attrs unsuccessfully' do
      put(:update, params: { id: card.id, card: new_card_attrs })

      expect(card.reload.original_text).to_not eq(new_card_attrs[:original_text])
    end

    it 'redirects to cards path after unsuccessful destroy' do
      delete(:destroy, params: { id: card.id })

      expect(response).to redirect_to(cards_path)
    end

    it 'changes card attrs unsuccessfully' do
      delete(:destroy, params: { id: card.id })

      expect(Card.where(id: card.id).first).to eq(card)
    end
  end
end
