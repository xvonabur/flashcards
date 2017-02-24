# frozen_string_literal: true
require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

RSpec.describe TranslationCheckController, type: :controller do
  context 'Guest runs forbidden operations' do
    let!(:user) { create(:user) }
    let!(:card) { create(:card, user: user, deck: create(:deck, user: user)) }

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
    let!(:card) { create(:card, user: user, deck: create(:deck, user: user)) }

    before { login_user user }

    it 'redirects to root url after successful update' do
      post(:create, params: {
        card: { id: card.id, text_to_check: card.original_text }
      })

      expect(response).to redirect_to(root_url)
    end

    it 'changes card review date successfully' do
      travel_to Time.new(2017, 2, 22, 10, 0) do
        post(:create, params: {
          card: { id: card.id, text_to_check: card.original_text }
        })
        expect(card.reload.review_date).to eq(Time.current + 12.hours)
      end
    end
  end

  context 'User manipulates not owned card data' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user, email: 'abc@mail.com') }
    let!(:card) do
      create(:card, user: another_user, deck: create(:deck, user: another_user))
    end

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
