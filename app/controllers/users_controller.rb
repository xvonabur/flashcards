# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create, :index]
  before_action :get_user_by_id, only: [:edit, :update, :destroy]

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
      redirect_to(translation_check_path, notice: I18n.t('users.create.success'))
    else
      render action: 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to(translation_check_path, notice: I18n.t('users.update.success'))
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
                                 :active_deck_id)
  end

  def get_user_by_id
    @user = User.find(params[:id])
  end
end
