# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Dashboard::UsersController, type: :controller do

  context 'Guest runs forbidden operations' do
    let!(:user) { create(:user) }
    let!(:new_email) { 'abc@mail.com' }

    it 'redirects to root url after trying to update a user' do
      put(:update, params: { id: user.id, user: { email: new_email } })
      expect(response).to redirect_to(root_url)
    end

    it 'does not change a user after trying to update her' do
      put(:update, params: { id: user.id, user: { email: new_email } })
      expect(user.reload.email).to_not eq(new_email)
    end

    it 'redirects to root url after trying to delete a user' do
      delete(:destroy, params: { id: user.id })
      expect(response).to redirect_to(root_url)
    end

    it 'does not remove a user after trying to remove her' do
      delete(:destroy, params: { id: user.id })
      expect(user.reload).to eq(user)
    end
  end

  context 'User manipulates user data' do
    let!(:user) { create(:user) }
    let!(:deck) { create(:deck, user: user) }
    let!(:new_user_attrs) do
      { email: 'abc@mail.com', password:  'abc123',
        password_confirmation: 'abc123', active_deck_id: deck.id }
    end

    before { login_user user }

    it 'redirects to translation check page after successful update' do
      put(:update, params: { id: user.id, user: new_user_attrs })

      expect(response).to redirect_to(dashboard_translation_check_path)
    end

    it 'changes user email successfully' do
      put(:update, params: { id: user.id, user: new_user_attrs })

      expect(user.reload.email).to eq(new_user_attrs[:email])
    end

    it 'changes user active card successfully' do
      put(:update, params: { id: user.id, user: new_user_attrs })

      expect(user.reload.active_deck_id).to eq(new_user_attrs[:active_deck_id])
    end

    it 'redirects to root url after successful destroy' do
      delete(:destroy, params: { id: user.id })

      expect(response).to redirect_to(root_url)
    end

    it 'changes user attrs successfully' do
      delete(:destroy, params: { id: user.id })

      expect(User.where(id: user.id).first).to eq(nil)
    end
  end
end
