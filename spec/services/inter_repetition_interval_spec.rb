# frozen_string_literal: true
require 'rails_helper'

describe InterRepetitionInterval do
  it 'raises an error for empty last_interval' do
    interval = described_class.new(3)

    expect { interval.calc }.to raise_error(StandardError)
  end

  it 'raises an error for empty easiness_factor' do
    interval = described_class.new(3)

    expect { interval.calc(nil, 2) }.to raise_error(StandardError)
  end

  it 'returns right value for the first repetition' do
    interval = described_class.new(1)

    expect(interval.calc).to eq(1)
  end

  it 'returns right value for the second repetition' do
    interval = described_class.new(2)

    expect(interval.calc).to eq(6)
  end

  it 'returns right value for the third repetition' do
    interval = described_class.new(3)

    expect(interval.calc(4.1, 2)).to eq(9)
  end
end
