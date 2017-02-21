# frozen_string_literal: true
class Deck < ApplicationRecord
  belongs_to :user
  has_many :cards
  validates :name, :user_id, presence: true
end
