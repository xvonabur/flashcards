# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'User registration' do
  before do
    visit root_path
    find('#sign_up_link').click
  end

  context 'is successful' do
    let!(:new_user) { build(:user) }

    scenario 'prints welcome message' do
      fill_in 'user_email', with: new_user.email
      fill_in 'user_password', with: new_user.password
      fill_in 'user_password_confirmation', with: new_user.password

      find('input[type=submit]').click

      expect(page).to have_content I18n.t('home.users.create.success')
      expect(page).to_not have_css('form.user_session')
    end
  end

  context 'is not successful' do
    scenario 'prints error messages' do
      user = User.new
      user.validate

      find('input[type=submit]').click

      user.errors.messages.values do |error|
        expect(page).to have_content error
      end
    end
  end
end
