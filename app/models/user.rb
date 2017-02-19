# frozen_string_literal: true
class User < ApplicationRecord
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :cards, dependent: :destroy
  has_many :authentications, dependent: :destroy
  has_many :decks, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 },
            if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true,
            if: -> { new_record? || changes[:crypted_password] }

  def card_to_check
    active_cards = cards_from_active_deck
    return  active_cards.fetch_expired.random_one if active_cards.present?
    cards_from_my_decks.fetch_expired.random_one
  end

  private

  def cards_from_my_decks
    Card.joins(:deck).where(decks: { user_id: self.id })
  end

  def cards_from_active_deck
    cards_from_my_decks.where(decks: { active: true })
  end
end
