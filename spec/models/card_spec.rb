# frozen_string_literal: true
require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe Card, type: :model do
  TRAVEL_DATE = Time.new(2017, 2, 22, 10, 0, 0)


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
    it 'returns 0 for texts with different cases' do
      card = described_class.create(original_text: 'Original Text',
                                    translated_text: 'Оригинальный текст')
      expect(card.original_text_check('originaL tExt')).to eq(0)
    end

    it 'returns 0 for texts with the same cases' do
      card = described_class.create(original_text: 'Kawabanga',
                                    translated_text: 'Кавабанга')
      expect(card.original_text_check('Kawabanga')).to eq(0)
    end
  end

  context 'invalid translation check result' do
    it 'returns for different texts' do
      card = described_class.create(original_text: 'With great power',
                                    translated_text: 'Чем больше сила')
      expect(card.original_text_check('comes great responsibility')).to eq(17)
    end

    it 'returns for empty text_to_check' do
      card = described_class.create(original_text: "It's a trap!",
                                    translated_text: 'Это ловушка!')
      expect(card.original_text_check('')).to eq(12)
    end
  end

  it 'sets review date for new card' do
    travel_to Time.new(2017, 2, 22, 10, 0, 0) do
      card = build(:expired_card, review_date: Time.current)

      expect(card.review_date).to eq(Time.current)
    end
  end

  context 'Right review date update' do
    let!(:deck) { create(:deck) }
    let!(:travel_time) { Time.new(2017, 2, 22, 10, 0, 0) }

    it 'sets review date to tomorrow after first good check' do
      travel_to travel_time do
        card = create(:card, user: deck.user, deck: deck)

        card.right!(5)

        expect(card.reload.review_date).to eq(1.day.from_now)
      end
    end

    it 'sets review date to +6 days after second good check' do
      travel_to travel_time do
        card = create(:card, user: deck.user, rep_number: 1, deck: deck)

        card.right!(4)

        expect(card.reload.review_date).to eq(6.days.from_now)
      end
    end

    it 'sets review date to +26 days after third good check' do
      travel_to travel_time do
        card = create(:card, user: deck.user, rep_number: 2, interval: 6,
                      factor: 4.1, deck: deck)

        card.right!(5)

        expect(card.reload.review_date).to eq(26.days.from_now)
      end
    end

    it 'sets right review date after first bad check' do
      travel_to travel_time do
        card = create(:card, user: deck.user, deck: deck)

        card.wrong!(2)

        expect(card.reload.review_date).to eq(1.day.from_now)
      end
    end

    it 'sets right rep_number after first bad check with quality < 3' do
      travel_to travel_time do
        card = create(:card, user: deck.user, deck: deck, rep_number: 3, interval: 1)

        card.wrong!(2)

        expect(card.reload.rep_number).to eq(1)
      end
    end

    it 'returns only cards with quality < 4' do
      2.times { create(:expired_card, user: deck.user, deck: deck, quality: 4) }
      3.times { create(:expired_card, user: deck.user, deck: deck, quality: 1) }

      expect(described_class.to_review.count).to eq(3)
    end
  end

  private

  def create_cards(past_review_date: 3, future_review_date: 0)
    user = create(:user)
    deck = create(:deck, user: user)
    past_review_date.times do |n|
      create(:card, original_text: "Text #{n}", translated_text: "Текст #{n}",
             review_date: (n + 1).days.ago, user: user, deck: deck)
    end

    future_review_date.times do |n|
      create(:card, original_text: "Text #{n * 10}",
                    translated_text: "Текст #{n * 10}",
                    review_date: (n + 1).days.from_now,
                    user: user,
                    deck: deck)
    end
  end
end
