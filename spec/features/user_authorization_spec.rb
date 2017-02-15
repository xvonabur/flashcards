# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'User authorization' do
  context 'is successful' do
    let!(:user_attrs) { FactoryGirl.attributes_for(:user) }

    before do
      create(:user)
      visit root_path
    end

    scenario 'prints welcome message' do
      find('#sign_in_link').click

      fill_in 'user_session_email', with: user_attrs[:email]
      fill_in 'user_session_password', with: user_attrs[:password]
      find('input[type=submit]').click

      expect(page).to have_content I18n.t('user_sessions.create.success')
    end
  end

  context 'is not successful' do
    let!(:user) { create(:user) }

    scenario 'prints error messages' do
      visit root_path
      find('#sign_in_link').click

      find('input[type=submit]').click

      expect(page).to have_content I18n.t('user_sessions.create.failure')
    end
  end
end
