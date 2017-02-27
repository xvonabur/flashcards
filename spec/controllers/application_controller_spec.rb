# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  it 'returns right locale for logged in user' do
    user = create(:user)
    login_user user

    expect(controller.current_locale).to eq('ru')
  end

  it 'returns right locale for URL attribute' do
    controller.params[:locale] = 'en'

    expect(controller.current_locale).to eq('en')
  end

  it 'returns right locale for session' do
    controller.session[:locale] = 'en'

    expect(controller.current_locale).to eq('en')
  end
end
