# frozen_string_literal: true
class TranslationCheckController < ApplicationController
  before_action :require_login
  before_action :fetch_owned_card, only: :create

  def show
    @card = Card.where(user_id: current_user.id).fetch_expired.random_one
  end

  def create
    if @card.original_text_check(card_params[:text_to_check])
      @card.update_review_date
      flash[:success] = I18n.t('translation_check.results.good')
    else
      flash[:alert] = I18n.t('translation_check.results.bad')
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def card_params
    params.require(:card).permit(:id, :text_to_check)
  end

  def fetch_owned_card
    @card = Card.where(user_id: current_user.id, id: card_params[:id]).first

    return unless @card.blank?
    redirect_back(fallback_location: root_path)
  end
end
