# frozen_string_literal: true
module Dashboard
  class TranslationCheckController < ApplicationController
    before_action :require_login
    before_action :fetch_owned_card, only: :create
    before_action :fetch_card_to_check, only: :show

    def create
      distance = @card.original_text_check(card_params[:text_to_check])
      answer_time = card_params[:answer_time]
      update_card_attrs(distance, answer_time)

      respond_to do |format|
        format.html do
          flash.keep
          redirect_back(fallback_location: root_path)
        end
        format.js { fetch_card_to_check }
      end
    end

    private

    def card_params
      params.require(:card).permit(:id, :text_to_check, :answer_time)
    end

    def fetch_owned_card
      @card = current_user.cards.find_by(id: card_params[:id])

      return unless @card.blank?
      redirect_back(fallback_location: root_path)
    end

    def update_card_attrs(distance, answer_time)
      flash.clear
      if distance == 0
        @card.right!(answer_time)
        flash.now[:success] = t('.results.good')
      elsif distance <= 5
        @card.right!(answer_time)
        flash.now[:notice] = t('.results.typo',
                           original: @card.original_text,
                           translated: @card.translated_text,
                           passed: card_params[:text_to_check])
      else
        @card.wrong!(answer_time)
        flash.now[:alert] = t('.results.bad')
      end
    end

    def fetch_card_to_check
      @card = current_user.card_to_check
    end
  end
end