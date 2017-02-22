# frozen_string_literal: true
require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

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

  it 'sets review date for new card' do
    card = Card.new

    expect(card.review_date.to_date).to eq(Date.today)
  end

  context 'Right review date update' do
    let!(:deck) { create(:deck) }

    it 'sets review date to +12 hours after first good check' do
      travel_to Time.new(2017, 2, 22, 10, 0, 0) do
        card = create(:card, user: deck.user, good_checks: 0, deck: deck)

        card.add_good_check

        expect(card.reload.review_date).to eq((Time.current + 12.hours))
      end
    end

    it 'sets review date to +3 days after second good check' do
      travel_to Time.new(2017, 2, 22, 10, 0, 0) do
        card = create(:card, user: deck.user, good_checks: 1, deck: deck)

        card.add_good_check

        expect(card.reload.review_date).to eq((Time.current + 72.hours))
      end
    end

    it 'sets review date to +1 week after third good check' do
      travel_to Time.new(2017, 2, 22, 10, 0, 0) do
        card = create(:card, user: deck.user, good_checks: 2, deck: deck)

        card.add_good_check

        expect(card.reload.review_date).to eq((Time.current + 168.hours))
      end
    end

    it 'sets review date to +1 week after forth good check' do
      travel_to Time.new(2017, 2, 22, 10, 0, 0) do
        card = create(:card, user: deck.user, good_checks: 3, deck: deck)

        card.add_good_check

        expect(card.reload.review_date).to eq((Time.current + 336.hours))
      end
    end

    it 'sets review date to +1 week after forth good check' do
      travel_to Time.new(2017, 2, 22, 10, 0, 0) do
        card = create(:card, user: deck.user, good_checks: 4, deck: deck)

        card.add_good_check

        expect(card.reload.review_date).to eq((Time.current + 672.hours))
      end
    end

    it 'sets right review date after first bad check' do
      travel_to Time.new(2017, 2, 22, 10, 0, 0) do
        card = create(:card, user: deck.user, bad_checks: 0,
                             good_checks: 3, deck: deck)

        card.add_bad_check

        expect(card.reload.review_date).to eq(Time.current + 168.hours)
      end
    end

    it 'sets right review date after third bad check' do
      travel_to Time.new(2017, 2, 22, 10, 0, 0) do
        card = create(:card, user: deck.user, bad_checks: 2,
                      good_checks: 3, deck: deck)

        card.add_bad_check

        expect(card.reload.review_date).to eq(Time.current + 12.hours)
      end
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
