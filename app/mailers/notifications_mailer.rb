# frozen_string_literal: true
class NotificationsMailer < ApplicationMailer
  def pending_cards(user_id)
    @user_email = User.find(user_id).email
    mail(to: @user_email, subject: 'Come back! We have cookies!')
  end
end
