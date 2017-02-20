# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Translation check' do
  # use let! to force the method's invocation before each example.
  let!(:user) { create(:user) }

  before(:each) do
    login user
  end

  context 'Card with image' do
    let!(:expired_card) do
      create(:card_with_image, user: user, deck: create(:deck, user: user))
    end

    before(:each) do
      visit translation_check_path
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

    scenario 'User sees a card image' do
      expect(page).to have_css("img[src*='#{File.basename fixture_image_path}']")
    end
  end

  context 'Card without image' do
    let!(:expired_card) do
      create(:expired_card, user: user, deck: create(:deck, user: user))
    end

    before(:each) do
      visit translation_check_path
    end

    scenario 'User sees a default card image' do
      expect(page).to have_css("img[src*='no_image']")
    end
  end

  context 'Card from active deck' do
    let!(:active_deck) { create(:deck, user: user) }
    let!(:deck) { create(:deck, user: user) }
    let!(:active_deck_card) { create(:expired_card, user: user, deck: active_deck) }
    let!(:deck_card) { create(:expired_card, user: user, deck: deck) }

    scenario 'User sees an active deck card' do
      visit translation_check_path

      expect(page).to have_content(active_deck_card.translated_text)
    end
  end

  context 'Card from non active deck' do
    let!(:deck) { create(:deck, user: user) }
    let!(:deck_card) { create(:expired_card, user: user, deck: deck) }

    scenario 'User sees an active deck card' do
      visit translation_check_path

      expect(page).to have_content(deck_card.translated_text)
    end
  end
end
