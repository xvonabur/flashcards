# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'layouts/_navigation.html.erb' do
  context 'guest navigation' do
    before { render partial: 'layouts/navigation.html.erb' }

    it 'displays sign up link' do
      expect(rendered).to match I18n.t('navigation.links.sign_up')
    end

    it 'displays language change link to ru' do
      expect(rendered).to match 'ru'
    end

    it 'displays language change link to en' do
      expect(rendered).to match 'en'
    end

    it 'displays sign in link' do
      expect(rendered).to match I18n.t('navigation.links.sign_in')
    end

    it 'does not display log out link' do
      expect(rendered).to_not match I18n.t('navigation.links.log_out')
    end

    it 'does not display profile link' do
      expect(rendered).to_not match I18n.t('navigation.links.profile')
    end

    it 'does not display all cards link' do
      expect(rendered).to_not match I18n.t('navigation.links.all_cards')
    end

    it 'does not display new card link' do
      expect(rendered).to_not match I18n.t('navigation.links.new_card')
    end

    it 'does not display new deck link' do
      expect(rendered).to_not match I18n.t('navigation.links.new_deck')
    end

    it 'does not display all decks link' do
      expect(rendered).to_not match I18n.t('navigation.links.all_decks')
    end
  end

  context 'user navigation' do
    before do
      user = create(:user)
      render partial: 'layouts/navigation.html.erb', locals: { current_user: user }
    end

    it 'does not display sign up link' do
      expect(rendered).to_not match I18n.t('navigation.links.sign_up')
    end

    it 'does not display sign in link' do
      expect(rendered).to_not match I18n.t('navigation.links.sign_in')
    end

    it 'does not display language change link to ru' do
      expect(rendered).to_not match 'ru'
    end

    it 'does not display language change link to en' do
      expect(rendered).to_not match 'en'
    end

    it 'displays log out link' do
      expect(rendered).to match I18n.t('navigation.links.log_out')
    end

    it 'displays profile link' do
      expect(rendered).to match I18n.t('navigation.links.profile')
    end

    it 'displays all cards link' do
      expect(rendered).to match I18n.t('navigation.links.all_cards')
    end

    it 'displays new card link' do
      expect(rendered).to match I18n.t('navigation.links.new_card')
    end

    it 'displays new deck link' do
      expect(rendered).to match I18n.t('navigation.links.new_deck')
    end

    it 'displays all decks link' do
      expect(rendered).to match I18n.t('navigation.links.all_decks')
    end
  end
end
