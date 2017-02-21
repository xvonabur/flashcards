# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Cards manipulation' do
  # use let! to force the method's invocation before each example.
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user, email: 'abc@mail.com') }
  let!(:another_user_deck) { create(:deck, user: another_user) }
  let!(:deck) { create(:deck, user: user) }
  let!(:expired_card) do
    create(:expired_card, user: another_user, deck: another_user_deck)
  end

  before { login user }

  scenario 'User tries to edit not owned card' do
    visit edit_card_path(expired_card.id)
    expect(page).to have_text(I18n.t('common_errors.access_forbidden'))
  end

  context 'User sees only his cards' do
    let!(:user_card) do
      create(:another_expired_card, user: user, deck: deck)
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
      FactoryGirl.attributes_for(:another_expired_card, user: user, deck: deck)
    end

    context 'successfully' do
      before do
        visit new_card_path

        fill_in 'card_original_text', with: new_card_attrs[:original_text]
        fill_in 'card_translated_text', with: new_card_attrs[:translated_text]
        select deck.name, from: 'card_deck_id'
      end

      scenario 'and db saves it' do
        find('input[type=submit]').click

        expect(Card.last.original_text).to eq(new_card_attrs[:original_text])
      end

      scenario 'with uploaded image' do
        attach_file('card[image]', fixture_image_path)

        find('input[type=submit]').click

        expect(
          Card.last.image.file.original_filename
        ).to eq(File.basename fixture_image_path)
      end

      scenario 'with image URL' do
        fill_in 'card_remote_image_url', with: fixture_image_url

        find('input[type=submit]').click

        expect(
          Card.last.image.file.original_filename
        ).to eq(File.basename fixture_image_url)
      end

      scenario 'with deck' do
        select deck.name, from: 'card_deck_id'

        find('input[type=submit]').click

        expect(Card.last.deck_id).to eq(deck.id)
      end

      scenario 'with review date' do
        select '1', from: 'card[review_date(3i)]'
        select I18n.t('date.common_month_names')[2], from: 'card[review_date(2i)]'
        select '2016', from: 'card[review_date(1i)]'

        find('input[type=submit]').click

        expect(Card.last.review_date).to eq(Date.new(2016, 2, 1))
      end

      scenario 'form does not have remove card checkbox' do
        expect(page).to_not have_css('.card_remove_image')
      end
    end

    context 'User edits card' do
      let!(:curr_user_card) { create(:card_with_image, user: user, deck: deck) }

      before do
        visit edit_card_path(curr_user_card.id)
      end

      scenario 'sees an image' do
        expect(page).to have_css("img[src*='#{File.basename fixture_image_path}']")
      end

      scenario 'removes an image' do
        check 'card_remove_image'

        find('input[type=submit]').click

        expect(curr_user_card.reload.image.file.nil?).to be_truthy
      end
    end

    context 'unsuccessfully' do
      before do
        visit new_card_path

        find('input[type=submit]').click
      end

      scenario 'and does see errors' do
        card = build(:another_expired_card, user: user, deck: deck)
        card.valid?

        card.errors.messages.values.each do |mess|
          expect(page).to have_content(mess)
        end
      end
    end
  end
end
