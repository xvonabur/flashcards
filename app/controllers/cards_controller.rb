# frozen_string_literal: true
class CardsController < ApplicationController
  before_action :require_login
  before_action :fetch_card, only: [:show, :edit, :destroy, :update]

  def index
    @cards = Card.where(user_id: current_user.id)
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)
    @card.user = current_user

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
                                 :review_date)
  end

  def fetch_card
    @card = Card.where(id: params[:id]).first
    return if @card.user_id == current_user.id
    flash[:error] = I18n.t('common_errors.access_forbidden')
    redirect_to cards_path
  end
end
