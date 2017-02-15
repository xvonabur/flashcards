# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TranslationCheckController, type: :controller do
  context 'Guest runs forbidden operations' do
    let!(:card) { create(:card) }

    it 'redirects to root url for unsuccessful try to view card' do
      get(:show, params: { card: { id: card.id }})
      expect(response).to redirect_to(root_url)
    end

    it 'redirects to root url for unsuccessful translation check' do
      post(:create, params: {
        card: { id: card.id, text_to_check: card.original_text }
      })
      expect(response).to redirect_to(root_url)
    end

    it 'does not change card for unsuccessful translation check' do
      expect {
        post(:create, params: {
          card: { id: card.id, text_to_check: card.original_text }
        })
      }.to_not change { card.reload.review_date }
    end
  end

  context 'User manipulates her card data' do
    let!(:user) { create(:user) }
    let!(:card) { create(:card, user: user) }

    before { login_user user }

    it 'redirects to root url after successful update' do
      post(:create, params: {
        card: { id: card.id, text_to_check: card.original_text }
      })

      expect(response).to redirect_to(root_url)
    end

    it 'changes card review date successfully' do
      post(:create, params: {
        card: { id: card.id, text_to_check: card.original_text }
      })
      expect(card.review_date).to_not eq(card.reload.review_date)
    end
  end

  context 'User manipulates not owned card data' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user, email: 'abc@mail.com') }
    let!(:card) { create(:card, user: another_user) }

    before { login_user user }

    it 'redirects to root url after unsuccessful update' do
      post(:create, params: {
        card: { id: card.id, text_to_check: card.original_text }
      })

      expect(response).to redirect_to(root_url)
    end

    it 'changes card review date successfully' do
      expect {
        post(:create, params: {
          card: { id: card.id, text_to_check: card.original_text }
        })
      }.to_not change { card.reload.review_date }
    end
  end
end
