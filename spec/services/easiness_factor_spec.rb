# frozen_string_literal: true
require 'rails_helper'

describe EasinessFactor do
  context 'quality = 1' do
    let!(:factor) { described_class.new(1) }

    it 'raises an error for blank last_factor' do
      expect { factor.calc(nil) }.to raise_error(StandardError)
    end

    it 'returns 1.3 as minimum value' do
      expect(factor.calc(1)).to eq(1.3)
    end
  end

  it 'returns right value for good quality' do
    factor = described_class.new(5)

    expect(factor.calc(4)).to eq(4.1)
  end

  it 'returns right value for bad quality' do
    factor = described_class.new(3)

    expect(factor.calc(4)).to eq(3.86)
  end
end
