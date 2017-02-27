# frozen_string_literal: true
set :output, "#{Rails.path}/log/cron.log"

every :day do
  runner "User.notify_about_expired_cards"
end
