# frozen_string_literal: true
require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe  ImageUploader do
  include CarrierWave::Test::Matchers

  let(:card) { create(:card) }
  let(:uploader) { described_class.new(card, :image) }
  let(:base_image_path) { Rails.root.join('spec/fixtures/images') }
  let(:image_paths) do
    { png: base_image_path.join('bat-logo.png').to_s,
      jpg: base_image_path.join('bat-logo.jpg').to_s,
      jpeg: base_image_path.join('bat-logo.jpeg').to_s }
  end

  before do
    described_class.enable_processing = true
  end

  after do
    described_class.enable_processing = false
    uploader.remove!
  end

  [:png, :jpg, :jpeg].each do |ext|
    context "#{ext} image extension" do
      before do
        File.open(image_paths[ext]) { |f| uploader.store!(f) }
      end

      it 'scales down an image to be no larger than 360 by 360 pixels' do
        expect(uploader).to be_no_larger_than(360, 360)
      end

      it 'has the correct format' do
        ext_str = ext == :jpg ? 'jpeg' : ext.to_s
        expect(uploader).to be_format(ext_str)
      end
    end
  end

  it 'raises an error for non image file' do
    expect {
      File.open(Rails.root.join('.rubocop.yml')) { |f| uploader.store!(f) }
    }.to raise_error(CarrierWave::IntegrityError)
  end
end
