class DecksController < ApplicationController
  before_action :require_login
  before_action :fetch_deck, only: [:show, :edit, :destroy, :update]

  def index
    @decks = current_user.decks
  end

  def new
    @deck = Deck.new
  end

  def create
    @deck = current_user.decks.build(deck_params)

    if @deck.save
      redirect_to @deck
    else
      render 'new'
    end
  end

  def update
    if @deck.update(deck_params)
      redirect_to @deck
    else
      render 'edit'
    end
  end

  def destroy
    @deck.destroy

    redirect_to decks_path
  end

  private

  def deck_params
    params.require(:deck).permit(:name, :user_id, :active)
  end

  def fetch_deck
    @deck = current_user.decks.find_by(id: params[:id])
    return if @deck.present?
    flash[:error] = I18n.t('common_errors.access_forbidden')
    redirect_to decks_path
  end
end
