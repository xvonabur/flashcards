# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  def set_locale
    locale = current_locale
    if locale && I18n.available_locales.include?(locale.to_sym)
      session[:locale] = I18n.locale = locale.to_sym
    end
  end

  def current_locale
    if current_user
      current_user.locale
    elsif params.present? && params[:locale]
      params[:locale]
    elsif session.present? && session[:locale]
      session[:locale]
    else
      http_accept_language.compatible_language_from(I18n.available_locales)
    end
  end
end
