# frozen_string_literal: true
require 'levenshtein'

class Card < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  mount_uploader :image, ImageUploader

  after_initialize :default_review_date

  validates :original_text, :translated_text, :user_id, :deck_id, presence: true
  validates :review_date, presence: true, on: :create
  validate :texts_are_different?

  scope :random_one, -> { order('RANDOM()').first }
  scope :fetch_expired, -> { where('review_date <= ?', Time.now.end_of_day) }

  DELAYS = [0, 12, 72, 168, 336, 672]

  def original_text_check(translation)
    Levenshtein.distance(cleaned_text(self.original_text),
                         cleaned_text(translation.to_s).to_s)
  end

  def right!
    self.right_count += 1
    self.wrong_count = 0
    assign_review_date
    save
  end

  def wrong!
    self.right_count = 1 if self.wrong_count == 2
    self.wrong_count += 1
    assign_review_date
    save
  end

  private

  def texts_are_different?
    return if cleaned_text(self.original_text) != cleaned_text(self.translated_text)
    [:original_text, :translated_text].each do |attr|
      errors.add(attr, I18n.t('cards.errors.texts_are_equal'))
    end
  end

  def cleaned_text(text)
    return nil if text.blank?
    text.strip.mb_chars.downcase!.to_s
  end

  def default_review_date
    self.review_date ||= Time.current
  end

  def assign_review_date
    self.review_date = DELAYS[self.right_count].hours.from_now
  end
end
