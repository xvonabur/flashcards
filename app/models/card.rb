# frozen_string_literal: true
class Card < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  mount_uploader :image, ImageUploader

  after_initialize :assign_review_date

  validates :original_text, :translated_text, :user_id, :deck_id, presence: true
  validates :review_date, presence: true, on: :create
  validate :texts_are_different?

  scope :random_one, -> { order('RANDOM()').first }
  scope :fetch_expired, -> { where('review_date <= ?', Time.now.end_of_day) }

  def original_text_check(translation)
    cleaned_text(self.original_text) == cleaned_text(translation.to_s)
  end

  def add_good_check
    self.update(good_checks: self.good_checks + 1, bad_checks: 0)
    update_review_date
  end

  def add_bad_check
    self.good_checks = 1 if self.bad_checks == 2
    self.bad_checks = self.bad_checks + 1
    self.save
    update_review_date
  end

  private

  def update_review_date
    self.update(review_date: self.class.delays[self.good_checks].hours.from_now)
  end

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

  def assign_review_date
    self.review_date ||= Date.today
  end

  def self.delays
    [0, 12, 72, 168, 336, 672]
  end
end
