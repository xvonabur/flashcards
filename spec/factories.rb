# frozen_string_literal: true
FactoryGirl.define do
  factory :card do
    original_text     "This looks like a job for superman"
    translated_text   "Doesn't need translation"
    review_date       3.days.from_now
  end

  factory :expired_card, class: Card do
    original_text     "If you’re good at something, never do it for free"
    translated_text   "Если ты хорош в чем-то, никогда не делай это за бесплатно"
    review_date       3.days.ago
  end
end
