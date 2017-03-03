# frozen_string_literal: true
module Home
  class OauthsController < ApplicationController
    skip_before_action :require_login, raise: false

    # sends the user on a trip to the provider,
    # and after authorizing there back to the callback url.
    def oauth
      login_at(auth_params[:provider])
    end

    def callback
      provider = auth_params[:provider]
      if @user = login_from(provider)
        redirect_to root_path, notice: success_message(provider)
      else
        begin
          @user = create_from(provider)
          reset_session # protect from session fixation attack
          auto_login(@user)
          redirect_to root_path, notice: success_message(provider)
        rescue
          redirect_to root_path, alert: failure_message(provider)
        end
      end
    end

    private

    def success_message(provider)
      "#{t('.success')} #{provider.titleize}!"
    end

    def failure_message(provider)
      "#{t('.failure')} #{provider.titleize}!"
    end

    def auth_params
      params.permit(:code, :provider)
    end
  end
end
