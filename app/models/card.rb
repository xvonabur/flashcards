# frozen_string_literal: true
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
    cleaned_text(self.original_text) == cleaned_text(translation.to_s)
  end

  def right!
    self.right_results += 1
    self.wrong_results = 0
    assign_review_date
    self.save
  end

  def wrong!
    self.right_results = 1 if self.wrong_results == 2
    self.wrong_results += 1
    assign_review_date
    self.save
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
    self.review_date = DELAYS[self.right_results].hours.from_now
  end
end
