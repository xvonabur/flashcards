# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Locale change' do
  it 'displays right locale for russian browser' do
    Capybara.current_session.driver.header 'Accept-Language', 'ru'

    visit root_path

    expect(page).to have_content(I18n.t('header.title', locale: :ru))
  end

  it 'displays right locale for english browser' do
    Capybara.current_session.driver.header 'Accept-Language', 'en'

    visit root_path

    expect(page).to have_content(I18n.t('header.title', locale: :en))
  end

  it 'changes locale by link' do
    Capybara.current_session.driver.header 'Accept-Language', 'en'

    visit root_path
    find('#locale-ru').click

    expect(page).to have_content(I18n.t('header.title', locale: :ru))
  end
end
