# frozen_string_literal: true
FactoryGirl.define do
  factory :authentication do
    
  end
  factory :card do
    original_text     "This looks like a job for superman"
    translated_text   "Doesn't need translation"
    review_date       3.days.from_now
    user
  end

  factory :expired_card, parent: :card do
    review_date       3.days.ago
  end

  factory :another_expired_card, parent: :expired_card do
    original_text     "The night is darkest before the dawn."
    translated_text   "And I promise you, the dawn is coming."
  end

  factory :user do
    email 'user@mail.com'
    password 'password123'
  end
end
