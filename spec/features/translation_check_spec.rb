# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Translation check' do
  # use let! to force the method's invocation before each example.
  let!(:expired_card) { create(:expired_card) }

  before(:each) do
    visit root_path
  end

  scenario 'User enters wright translation' do
    original = expired_card.original_text

    fill_in 'card_text_to_check', with: original
    click_button I18n.t('translation_check.form.labels.check_btn')

    expect(page).to have_text(I18n.t('translation_check.results.good'))
  end

  scenario 'User enters wrong translation' do
    fill_in 'card_text_to_check', with: '123'
    click_button I18n.t('translation_check.form.labels.check_btn')

    expect(page).to have_text(I18n.t('translation_check.results.bad'))
  end
end
