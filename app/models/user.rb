# frozen_string_literal: true
class User < ApplicationRecord
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :cards, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_many :decks, dependent: :destroy
  belongs_to :active_deck, class_name: Deck, foreign_key: 'active_deck_id'
  accepts_nested_attributes_for :authentications

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 },
            if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true,
            if: -> { new_record? || changes[:crypted_password] }

  def card_to_check
    active_deck = self.active_deck
    active_deck.present? ? pick_card(active_deck.cards) : pick_card(self.cards)
  end

  private

  def pick_card(cards)
    cards.blank? ? nil : cards.fetch_expired.random_one
  end
end
