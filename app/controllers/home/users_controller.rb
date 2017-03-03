# frozen_string_literal: true
module Home
  class UsersController < ApplicationController
    before_action :fetch_decks, only: :create

    def index
      redirect_to(new_user_path)
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        login(user_params[:email], user_params[:password])
        redirect_to(dashboard_translation_check_path, notice: t('.success'))
      else
        render action: 'new'
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :active_deck_id, :locale)
    end

    def fetch_decks
      @decks = current_user.present? ? current_user.decks : nil
    end
  end
end
