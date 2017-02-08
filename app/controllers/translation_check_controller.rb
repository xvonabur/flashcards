# frozen_string_literal: true
class TranslationCheckController < ApplicationController
  before_action :fetch_card_by_id, only: :create

  def show
    @card = Card.fetch_expired.random_one
  end

  def create
    check_result = @card.original_text_check(card_params[:text_to_check])

    if check_result
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

  def fetch_card_by_id
    @card = Card.find(card_params[:id])
  end
end
