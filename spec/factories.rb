# frozen_string_literal: true
FactoryGirl.define do
  factory :card do
    original_text     "This looks like a job for superman"
    translated_text   "Doesn't need translation"
    review_date       3.days.from_now
  end

  factory :expired_card, parent: :card do
    review_date       3.days.ago
  end
end
