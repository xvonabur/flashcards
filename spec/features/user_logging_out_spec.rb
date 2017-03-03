# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'User logging out' do

  context 'is successful' do
    before do
      user = create(:user)
      login user
      visit dashboard_translation_check_path
    end

    scenario 'prints goodbye message' do
      find('#log_out_link').click

      expect(page).to have_content I18n.t('dashboard.user_sessions.destroy.success')
    end
  end
end
