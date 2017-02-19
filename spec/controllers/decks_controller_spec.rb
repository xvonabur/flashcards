require 'rails_helper'

RSpec.describe DecksController, type: :controller do
  context 'Guest runs forbidden operations' do
    let!(:deck) { create(:deck) }
    let!(:new_name) { 'New name' }

    it 'does not change a deck after trying to update it' do
      put(:update, params: { id: deck.id, deck: { name: new_name } })
      expect(deck.reload.name).to_not eq(new_name)
    end

    it 'does not remove a deck after trying to remove it' do
      delete(:destroy, params: { id: deck.id })
      expect(deck.reload).to eq(deck)
    end
  end

  context 'User manipulates his deck data' do
    let!(:user) { create(:user) }
    let!(:deck) { create(:deck, user: user) }
    let!(:new_deck_attrs) do
      { name: 'New deck name', active: true }
    end

    before { login_user user }

    it 'changes deck name successfully' do
      put(:update, params: { id: deck.id, deck: new_deck_attrs })

      expect(deck.reload.name).to eq(new_deck_attrs[:name])
    end

    it 'changes deck active status successfully' do
      put(:update, params: { id: deck.id, deck: new_deck_attrs })

      expect(deck.reload.active).to eq(new_deck_attrs[:active])
    end

    it 'changes deck attrs successfully' do
      delete(:destroy, params: { id: deck.id })

      expect(Deck.find_by(id: deck.id)).to eq(nil)
    end
  end

  context 'User manipulates not owned deck data' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user, email: 'abc@mail.com') }
    let!(:deck) { create(:deck, user: another_user) }
    let!(:new_deck_attrs) do
      { name: 'New deck name' }
    end

    before { login_user user }

    it 'changes deck attrs unsuccessfully' do
      put(:update, params: { id: deck.id, deck: new_deck_attrs })

      expect(deck.reload.name).to_not eq(new_deck_attrs[:name])
    end

    it 'changes deck attrs unsuccessfully' do
      delete(:destroy, params: { id: deck.id })

      expect(Deck.find_by(id: deck.id)).to eq(deck)
    end
  end
end
