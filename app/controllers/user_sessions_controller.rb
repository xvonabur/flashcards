# frozen_string_literal: true
class UserSessionsController < ApplicationController
  before_action :require_login, only: :destroy
  before_action :already_signed_in?, only: :new

  def new
    @user = User.new
  end

  def create
    if @user = login(session_params[:email], session_params[:password])
      redirect_back_or_to(translation_check_path,
                          notice: I18n.t('user_sessions.create.success'))
    else
      flash.now[:alert] = I18n.t('user_sessions.create.failure')
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(root_path, notice: I18n.t('user_sessions.destroy.success'))
  end

  private

  def session_params
    params.require(:user_session).permit(:email, :password)
  end

  def already_signed_in?
    return unless logged_in?
    redirect_to(cards_path)
  end
end
