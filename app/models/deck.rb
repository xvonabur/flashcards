class Deck < ApplicationRecord
  attr_accessor :active

  belongs_to :user
  has_many :cards
  validates :name, :user_id, presence: true

  before_save :make_active

  def make_active
    self.user.update(active_deck_id: self.id) if self.active
  end
end
