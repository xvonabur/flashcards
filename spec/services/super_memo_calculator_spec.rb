# frozen_string_literal: true
require 'rails_helper'

describe SuperMemoCalculator do
  context 'good quality' do
    let(:params) do
      { right_answer: true, last_factor: 4, last_rep_number: 1, last_interval: 1 }
    end

    it 'returns right quality for 10 seconds' do
      params[:seconds] = 10
      expect(described_class.new(params).quality).to eq(5)
    end

    it 'returns right quality for 20 seconds' do
      params[:seconds] = 20
      expect(described_class.new(params).quality).to eq(4)
    end

    it 'returns right quality for 40 seconds' do
      params[:seconds] = 40
      expect(described_class.new(params).quality).to eq(3)
    end
  end

  context 'bad quality' do
    let(:params) do
      { right_answer: false, last_factor: 2, last_rep_number: 1, last_interval: 1 }
    end

    it 'returns right quality for 10 seconds' do
      params[:seconds] = 10
      expect(described_class.new(params).quality).to eq(2)
    end

    it 'returns right quality for 20 seconds' do
      params[:seconds] = 20
      expect(described_class.new(params).quality).to eq(1)
    end

    it 'returns right quality for 40 seconds' do
      params[:seconds] = 40
      expect(described_class.new(params).quality).to eq(0)
    end
  end

  context 'other calculator attributes' do
    let(:calculator) do
      described_class.new(right_answer: true, last_factor: 4, last_rep_number: 2,
                          last_interval: 1, seconds: 10)
    end

    it 'returns factor value' do
      expect(calculator.factor).to eq(4.1)
    end

    it 'returns rep_number for good quality' do
      expect(calculator.rep_number).to eq(3)
    end

    it 'returns rep_number for bad quality' do
      calculator = described_class.new(right_answer: false, last_factor: 4,
                                       last_rep_number: 1, last_interval: 1,
                                       seconds: 40)

      expect(calculator.rep_number).to eq(1)
    end

    it 'returns interval' do
      expect(calculator.interval).to eq(5)
    end
  end
end
