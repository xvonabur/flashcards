require 'rails_helper'

RSpec.describe Deck, type: :model do
  let!(:user) { create(:user) }
  let!(:active_deck) { create(:active_deck, user: user) }

  it 'returns only active decks' do
    2.times { create(:deck, user: user) }

    expect(described_class.active.count).to eq(1)
  end

  context 'active deck' do
    let!(:deck) { deck = create(:deck, user: user) }

    before { deck.update(active: true) }

    it 'can be only one active deck at a time' do
      expect(described_class.active.count).to eq(1)
    end

    it 'changes active deck after update' do
      expect(described_class.active.first).to eq(deck.reload)
    end
  end
end
