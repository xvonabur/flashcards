# frozen_string_literal: true
class TranslationCheckController < ApplicationController
  def show
    @card = Card.fetch_expired.random_one
  end

  def create
    @card = Card.find(card_params[:id])
    @card.text_to_check = card_params[:text_to_check]

    if @card.save
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
end
