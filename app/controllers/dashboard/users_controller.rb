# frozen_string_literal: true
module Dashboard
  class UsersController < ApplicationController
    before_action :require_login
    before_action :get_user_by_id, only: [:edit, :update, :destroy]
    before_action :fetch_decks, only: [:edit, :update]

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to(dashboard_translation_check_path, notice: t('.success', locale: user_locale))
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
end

