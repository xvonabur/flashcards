# frozen_string_literal: true
class Card < ApplicationRecord
  after_initialize :assign_review_date
  before_update :original_text_check, if: ->(card){ card.text_to_check.present? }

  validates :original_text, :translated_text, presence: true
  validates :review_date, presence: true, on: :create
  validate :texts_are_different?

  attr_accessor :text_to_check

  scope :random_one, -> { order('RANDOM()').first }
  scope :fetch_expired, -> { where('review_date <= ?', Time.now.end_of_day) }

  def original_text_check
    db_text = cleaned_text(self.original_text)
    passed_text = cleaned_text(self.text_to_check)
    throw :abort if db_text != passed_text
    self.review_date = 3.days.from_now
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

  def assign_review_date
    self.review_date ||= 3.days.from_now
  end
end
