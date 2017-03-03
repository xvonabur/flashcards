# frozen_string_literal: true
module Home
  class UserSessionsController < ApplicationController
    before_action :already_signed_in?, only: :new

    def new
      @user = User.new
    end

    def create
      if @user = login(session_params[:email], session_params[:password])
        redirect_back_or_to(dashboard_translation_check_path,
                            notice: t('.create.success'))
      else
        flash.now[:alert] = t('.create.failure')
        render action: 'new'
      end
    end

    private

    def session_params
      params.require(:user_session).permit(:email, :password)
    end

    def already_signed_in?
      return unless logged_in?
      redirect_to(dashboard_translation_check_path)
    end
  end
end
