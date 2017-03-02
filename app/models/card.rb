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
  scope :to_review, -> { fetch_expired.where('quality < 4') }

  def original_text_check(translation)
    Levenshtein.distance(cleaned_text(self.original_text),
                         cleaned_text(translation.to_s).to_s)
  end

  def right!(seconds)
    update_review_attrs(seconds, true)
  end

  def wrong!(seconds)
    update_review_attrs(seconds, false)
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

  def update_review_attrs(seconds, right_answer)
    calculator =
      SuperMemoCalculator.new(seconds: seconds, right_answer: right_answer,
                              last_factor: self.factor,
                              last_rep_number: self.rep_number,
                              last_interval: self.interval)

    update(quality: calculator.quality, factor: calculator.factor,
           rep_number: calculator.rep_number, interval: calculator.interval,
           review_date: calculator.interval.days.from_now)
  end
end
