# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Dashboard::UserSessionsController, type: :controller do
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

    it 'redirects to root url after successful log out' do
      delete(:destroy, params: { user_session: { id: user.id } })

      expect(response).to redirect_to(root_url)
    end
  end
end
