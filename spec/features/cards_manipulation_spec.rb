# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Cards manipulation' do
  # use let! to force the method's invocation before each example.
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user, email: 'abc@mail.com') }
  let!(:expired_card) { create(:expired_card, user: another_user) }

  before { login user }

  scenario 'User tries to edit not owned card' do
    visit edit_card_path(expired_card.id)
    expect(page).to have_text(I18n.t('common_errors.access_forbidden'))
  end

  context 'User sees only his cards' do
    let!(:user_card) do
      create(:another_expired_card, user: user)
    end

    before { visit cards_path }

    scenario 'User sees only one card' do
      expect(page).to have_css('.card-block', count: 1)
    end

    scenario 'User sees only his card text' do
      expect(page).to have_content(user_card.original_text)
    end
  end

  context 'User creates a card' do
    let!(:new_card_attrs) do
      FactoryGirl.attributes_for(:another_expired_card, user: user)
    end

    context 'successfully' do
      before do
        visit new_card_path

        fill_in 'card_original_text', with: new_card_attrs[:original_text]
        fill_in 'card_translated_text', with: new_card_attrs[:translated_text]
        find('input[type=submit]').click
      end

      scenario 'and does see a card original text' do
        expect(page).to have_content(new_card_attrs[:original_text])
      end
    end

    context 'unsuccessfully' do
      before do
        visit new_card_path

        find('input[type=submit]').click
      end

      scenario 'and does see errors' do
        card = build(:another_expired_card, user: user)
        card.valid?

        card.errors.messages.values.each do |mess|
          expect(page).to have_content(mess)
        end
      end
    end
  end
end
