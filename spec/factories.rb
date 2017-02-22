# frozen_string_literal: true
FactoryGirl.define do
  factory :deck do
    sequence(:name) { |n| "Awesome deck #{n}" }
    user
  end

  factory :active_deck, parent: :deck do
    after(:create) do |obj|
      obj.user.update(active_deck_id: obj.id)
    end
  end

  factory :card do
    original_text     "This looks like a job for superman"
    translated_text   "Doesn't need translation"
    review_date       3.days.from_now
    good_checks       0
    bad_checks        0
    user
    deck
  end

  factory :expired_card, parent: :card do
    review_date       3.days.ago
  end

  factory :another_expired_card, parent: :expired_card do
    original_text     "The night is darkest before the dawn."
    translated_text   "And I promise you, the dawn is coming."
  end

  factory :card_with_image, parent: :another_expired_card do
    image { Rack::Test::UploadedFile.new(fixture_image_path) }
  end

  factory :user do
    email 'user@mail.com'
    password 'password123'
  end
end

def fixture_image_path(ext = 'png')
  File.join(Rails.root, 'spec', 'fixtures', 'images', "bat-logo.#{ext}")
end

def fixture_image_url
  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Ruby_on_Rails_logo.svg'\
  '/400px-Ruby_on_Rails_logo.svg.png'
end
