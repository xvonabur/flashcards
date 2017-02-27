# frozen_string_literal: true
# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class NotificationsMailerPreview < ActionMailer::Preview
  def pending_cards
    NotificationsMailer.pending_cards(User.first.id)
  end
end
