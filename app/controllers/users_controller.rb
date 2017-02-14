# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]

  def index
    current_user.blank? ? redirect_to(new_user_path) : redirect_to(root_path)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to(translation_check_path, notice: I18n.t('users.create.success'))
    else
      render action: 'new'
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to(translation_check_path, notice: I18n.t('users.update.success'))
    else
      render action: 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to(root_path)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
