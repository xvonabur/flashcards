# frozen_string_literal: true
set :output, "#{Rails.path}/log/cron.log"

every :day do
  runner "NotificationsMailer.pending_cards.deliver_now"
end
