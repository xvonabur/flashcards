# frozen_string_literal: true
module Dashboard
  class UserSessionsController < ApplicationController
    before_action :require_login

    def destroy
      logout
      redirect_to(root_path, notice: t('.destroy.success'))
    end
  end
end
