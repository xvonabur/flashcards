# frozen_string_literal: true
class TranslationCheckController < ApplicationController
  before_action :require_login
  before_action :fetch_owned_card, only: :create

  def show
    @card = current_user.card_to_check
  end

  def create
    distance = @card.original_text_check(card_params[:text_to_check])
    if distance == 0
      @card.right!
      flash[:success] = I18n.t('translation_check.results.good')
    elsif distance <= 5
      @card.right!
      flash[:notice] = I18n.t('translation_check.results.typo',
                                original: @card.original_text,
                                translated: @card.translated_text,
                                passed: card_params[:text_to_check])
    else
      @card.wrong!
      flash[:alert] = I18n.t('translation_check.results.bad')
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def card_params
    params.require(:card).permit(:id, :text_to_check)
  end

  def fetch_owned_card
    @card = current_user.cards.find_by(id: card_params[:id])

    return unless @card.blank?
    redirect_back(fallback_location: root_path)
  end
end
