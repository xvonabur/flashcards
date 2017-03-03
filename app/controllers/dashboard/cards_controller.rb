# frozen_string_literal: true
module Dashboard
  class CardsController < ApplicationController
    before_action :require_login
    before_action :fetch_card, only: [:show, :edit, :destroy, :update]
    before_action :deck_exists?, only: [:new, :edit, :create]

    def index
      @cards = current_user.cards
    end

    def new
      @card = Card.new
    end

    def create
      @card = current_user.cards.build(card_params)

      if @card.save
        redirect_to dashboard_card_path(@card)
      else
        render 'new'
      end
    end

    def update
      if @card.update(card_params)
        redirect_to dashboard_card_path(@card)
      else
        render 'edit'
      end
    end

    def destroy
      @card.destroy

      redirect_to dashboard_cards_path
    end

    private

    def card_params
      params.require(:card).permit(:original_text, :translated_text,
                                   :review_date, :image, :image_cache,
                                   :remove_image, :remote_image_url, :deck_id)
    end

    def fetch_card
      @card = Card.find(params[:id])
      return if @card.user_id == current_user.id
      flash[:error] = t('common_errors.access_forbidden')
      redirect_to dashboard_cards_path
    end

    def deck_exists?
      @decks = current_user.decks
      return if @decks.present?
      flash[:error] = t('.errors.no_decks')
      redirect_to dashboard_cards_path
    end
  end
end
