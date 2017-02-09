# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Translation check' do
  before(:each) do
    create(:expired_card)
    visit root_path
  end

  scenario 'User enters wright translation' do
    translated = find('.card-title').text
    original = Card.where(translated_text: translated).pluck(:original_text).first

    fill_in 'card_text_to_check', with: original.to_s
    click_button I18n.t('translation_check.form.labels.check_btn')

    expect(page).to have_text(I18n.t('translation_check.results.good'))
  end

  scenario 'User enters wrong translation' do
    fill_in 'card_text_to_check', with: '123'
    click_button I18n.t('translation_check.form.labels.check_btn')

    expect(page).to have_text(I18n.t('translation_check.results.bad'))
  end
end
