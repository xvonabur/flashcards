# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Decks manipulation' do
  # use let! to force the method's invocation before each example.
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user, email: 'abc@mail.com') }
  let!(:another_user_deck) { create(:deck, user: another_user) }

  before { login user }

  scenario 'User tries to edit not owned deck' do
    visit edit_dashboard_deck_path(another_user_deck.id)
    expect(page).to have_text(I18n.t('common_errors.access_forbidden'))
  end

  context 'User sees only his decks' do
    let!(:another_deck) do
      create(:deck, user: user)
    end

    before { visit dashboard_decks_path }

    scenario 'User sees only one deck' do
      expect(page).to have_css('.card-block', count: 1)
    end

    scenario 'User sees only his deck name' do
      expect(page).to have_content(another_deck.name)
    end
  end

  context 'User creates a deck' do
    let!(:new_deck_attrs) do
      FactoryGirl.attributes_for(:deck, user: user)
    end

    context 'successfully' do
      before do
        visit new_dashboard_deck_path

        fill_in 'deck_name', with: new_deck_attrs[:name]
      end

      scenario 'and db saves it' do
        find('input[type=submit]').click

        expect(Deck.last.name).to eq(new_deck_attrs[:name])
      end
    end

    context 'User edits deck' do
      let!(:curr_user_deck) { create(:deck, user: user) }

      before do
        visit edit_dashboard_deck_path(curr_user_deck.id)
      end

      scenario 'and changes name' do
        fill_in 'deck_name', with: 'New shiny name'

        find('input[type=submit]').click

        expect(curr_user_deck.reload.name).to eq('New shiny name')
      end
    end

    context 'unsuccessfully' do
      before do
        visit new_dashboard_deck_path

        find('input[type=submit]').click
      end

      scenario 'and does see an error' do
        card = build(:deck, name: nil, user: user)
        card.valid?

        error = find('span.help-block').text

        expect(error).to eq(card.errors.messages.values.first.first)
      end
    end
  end
end
