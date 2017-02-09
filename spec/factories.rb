# frozen_string_literal: true
FactoryGirl.define do
  factory :card do
    sequence(:original_text)   { |n| "This looks like a job for superman #{n}" }
    sequence(:translated_text) { |n| "Doesn't need translation #{n}" }
    sequence(:review_date)     { |n| n.days.from_now }
  end

  factory :expired_card, class: Card do
    sequence(:original_text)   do |n|
      "If you’re good at something, never do it for free #{n}"
    end
    sequence(:translated_text) do |n|
      "Если ты хорош в чем-то, никогда не делай это за бесплатно #{n}"
    end
    sequence(:review_date)      { |n| n.days.ago }
  end
end
