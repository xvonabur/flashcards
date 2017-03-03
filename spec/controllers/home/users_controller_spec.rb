# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Home::UsersController, type: :controller do
  context 'Guest creates a user' do
    let!(:user_attrs) { FactoryGirl.attributes_for(:user) }

    it 'redirects to translation check page for successful operation' do
      post(:create, params: { user: user_attrs })
      expect(response).to redirect_to(dashboard_translation_check_path)
    end

    it 'creates a user for successful operation' do
      expect { post(:create, params: { user: user_attrs }) }.to change { User.count }
    end

    it 'redirects to registration page for unsuccessful operation' do
      post(:create, params: { user: { email: '', password: '' } })
      expect(response).to render_template(:new)
    end

    it 'does not create a user for unsuccessful operation' do
      expect {
        post(:create, params: { user: { email: '', password: '' } })
      }.to_not change { User.count }
    end
  end

  context 'Guest runs forbidden operations' do
    let!(:user) { create(:user) }
    let!(:new_email) { 'abc@mail.com' }

    it 'raises an error for nonexistent update route' do
      expect {
        put(:update, params: { id: user.id, user: { email: new_email } })
      }.to raise_error(ActionController::UrlGenerationError)
    end

    it 'raises an error for nonexistent destroy route' do
      expect {
        delete(:destroy, params: { id: user.id })
      }.to raise_error(ActionController::UrlGenerationError)
    end
  end
end
