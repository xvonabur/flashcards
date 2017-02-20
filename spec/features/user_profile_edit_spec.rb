# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'User profile edit' do
  let!(:new_user_attrs) { { email: 'abc@mail.com', password: 'abc123' } }
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck, user: user) }

  before do
    login user
    visit translation_check_path
    find('#user_profile_link').click
  end

  context 'is successful for owned profile' do
    scenario 'email and password' do
      fill_in 'user_email', with: new_user_attrs[:email]
      fill_in 'user_password', with: new_user_attrs[:password]
      fill_in 'user_password_confirmation', with: new_user_attrs[:password]

      find('input[type=submit]').click

      expect(page).to have_content I18n.t('users.update.success')
    end

    scenario 'only email' do
      fill_in 'user_email', with: new_user_attrs[:email]

      find('input[type=submit]').click

      expect(page).to have_content I18n.t('users.update.success')
    end

    scenario 'only password' do
      fill_in 'user_password', with: new_user_attrs[:password]
      fill_in 'user_password_confirmation', with: new_user_attrs[:password]

      find('input[type=submit]').click

      expect(page).to have_content I18n.t('users.update.success')
    end

    scenario 'only active deck' do
      select deck.name, from: 'user_active_deck_id'

      find('input[type=submit]').click

      expect(page).to have_content I18n.t('users.update.success')
    end
  end

  context 'is not successful' do
    scenario 'for not providing password confirmation' do
      fill_in 'user_email', with: new_user_attrs[:email]
      fill_in 'user_password', with: new_user_attrs[:password]

      find('input[type=submit]').click

      expect(page).to_not have_content I18n.t('users.update.success')
    end
  end
end
