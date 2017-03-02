# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create, :index]
  before_action :get_user_by_id, only: [:edit, :update, :destroy]
  before_action :fetch_decks, only: [:edit, :create, :update]

  def index
    redirect_to(new_user_path)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login(user_params[:email], user_params[:password])
      redirect_to(translation_check_path, notice: t('.success'))
    else
      render action: 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to(translation_check_path, notice: t('.success', locale: user_locale))
    else
      render action: 'edit'
    end
  end

  def destroy
    @user.destroy

    redirect_to(root_path)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :active_deck_id, :locale)
  end

  def get_user_by_id
    @user = User.find(params[:id])
  end

  def fetch_decks
    @decks = current_user.present? ? current_user.decks : nil
  end

  def user_locale
    user_params[:locale].blank? ? current_locale : user_params[:locale].to_s
  end
end
