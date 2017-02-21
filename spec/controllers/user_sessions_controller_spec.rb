# frozen_string_literal: true
require 'rails_helper'

RSpec.describe UserSessionsController, type: :controller do
  context 'Guest runs forbidden operations' do
    let!(:user) { create(:user) }

    it 'redirects to root url for unsuccessful operation' do
      delete(:destroy, params: { id: user.id })
      expect(response).to redirect_to(root_url)
    end
  end

  context 'User manipulates sessions' do
    let!(:user) { create(:user) }
    let!(:user_attrs) { FactoryGirl.attributes_for(:user) }

    before { login_user user }

    it 'redirects to translation check page for root url' do
      get :new

      expect(response).to redirect_to(translation_check_path)
    end

    it 'redirects to translation check page after successful login' do
      post(:create, params: {
        user_session: { email: user_attrs[:email], password: user_attrs[:password] }
      })

      expect(response).to redirect_to(translation_check_path)
    end

    it 'renders new action after unsuccessful login' do
      post(:create, params: {
        user_session: { email: user_attrs[:email], password: 'aaa123' }
      })

      expect(response).to render_template(:new)
    end

    it 'redirects to root url after successful log out' do
      delete(:destroy, params: { user_session: { id: user.id } })

      expect(response).to redirect_to(root_url)
    end
  end
end
