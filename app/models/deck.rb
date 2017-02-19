class Deck < ApplicationRecord
  belongs_to :user
  has_many :cards
  before_update :reset_active_status,
                if: ->(obj){ obj.active_changed? and obj.active == true }
  validates :name, :user_id, presence: true
  validates :active, inclusion: { in: [true, false] }

  scope :active, -> { where(active: true) }

  def reset_active_status
    current_active_deck = Deck.active.find_by(user_id: self.user_id)
    current_active_deck.update(active: false) if current_active_deck.present?
  end
end
