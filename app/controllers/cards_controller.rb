# frozen_string_literal: true
class CardsController < ApplicationController
  before_action :require_login
  before_action :fetch_card, only: [:show, :edit, :destroy, :update]

  def index
    @cards = current_user.cards
  end

  def new
    @card = Card.new
  end

  def create
    @card = current_user.cards.build(card_params)

    if @card.save
      redirect_to @card
    else
      render 'new'
    end
  end

  def update
    if @card.update(card_params)
      redirect_to @card
    else
      render 'edit'
    end
  end

  def destroy
    @card.destroy

    redirect_to cards_path
  end

  private

  def card_params
    params.require(:card).permit(:original_text, :translated_text,
                                 :review_date, :image, :image_cache,
                                 :remove_image, :remote_image_url)
  end

  def fetch_card
    @card = Card.find(params[:id])
    return if @card.user_id == current_user.id
    flash[:error] = I18n.t('common_errors.access_forbidden')
    redirect_to cards_path
  end
end
