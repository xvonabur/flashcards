# frozen_string_literal: true
require 'rails_helper'

describe Card, type: :model do
  context 'fetches expired cards' do
    it 'returns all expired cards' do
      create_cards(past_review_date: 3, future_review_date: 3)

      expect(Card.fetch_expired.count).to eq(3)
    end

    it 'returns no expired cards for empty db' do
      expect(Card.fetch_expired.count).to eq(0)
    end
  end

  context 'random one card' do
    before { create_cards }

    it 'returns persisted card' do
      expect(Card.random_one.persisted?).to eq(true)
    end

    it "doesn't create a new card" do
      Card.random_one

      expect(Card.count).to eq(3)
    end

    it "original text starts with Text" do
      card = Card.random_one

      expect(card.original_text.starts_with?('Text')).to eq(true)
    end

    it "translated text starts with Текст" do
      card = Card.random_one

      expect(card.translated_text.starts_with?('Текст')).to eq(true)
    end
  end

  context 'valid translation check result' do
    it 'returns for texts with different cases' do
      card = described_class.create(original_text: 'Original Text',
                                    translated_text: 'Оригинальный текст')
      expect(card.original_text_check('originaL tExt')).to eq(true)
    end

    it 'returns for texts with the same cases' do
      card = described_class.create(original_text: 'Kawabanga',
                                    translated_text: 'Кавабанга')
      expect(card.original_text_check('Kawabanga')).to eq(true)
    end
  end

  context 'invalid translation check result' do
    it 'returns for different texts' do
      card = described_class.create(original_text: 'With great power',
                                    translated_text: 'Чем больше сила')
      expect(card.original_text_check('comes great responsibility')).to eq(false)
    end

    it 'returns for empty text_to_check' do
      card = described_class.create(original_text: "It's a trap!",
                                    translated_text: 'Это ловушка!')
      expect(card.original_text_check('')).to eq(false)
    end
  end

  it 'sets review date to +3 days from now' do
    card = create(:card, original_text: '1', translated_text: '2',
                         review_date: Date.new(2017, 2, 2))

    card.update_review_date

    expect(card.review_date.to_date).to eq(3.days.from_now.to_date)
  end

  it 'sets review date for new card' do
    card = Card.new

    expect(card.review_date.to_date).to eq(3.days.from_now.to_date)
  end

  private

  def create_cards(past_review_date: 3, future_review_date: 0)
    user = create(:user)
    past_review_date.times do |n|
      create(:card, original_text: "Text #{n}", translated_text: "Текст #{n}",
             review_date: (n + 1).days.ago, user: user)
    end

    future_review_date.times do |n|
      create(:card, original_text: "Text #{n * 10}",
                    translated_text: "Текст #{n * 10}",
                    review_date: (n + 1).days.from_now,
                    user: user)
    end
  end
end
