require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with email and password' do
    user = build(:user)

    expect(user.valid?).to eq(true)
  end

  context 'invalid user' do
    it 'is invalid without email' do
      user = build(:user, email: nil)

      expect(user.valid?).to eq(false)
    end

    it 'is invalid without password' do
      user = build(:user, password: nil)

      expect(user.valid?).to eq(false)
    end
  end

  it 'has associated cards' do
    user = create(:user)
    [:card, :expired_card].each { |card_type| create(card_type, user: user) }

    expect(user.cards.count).to eq(2)
  end
end
