# frozen_string_literal: true
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fit: [360, 360]

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage Rails.env == 'test' ? :file : :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg png)
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path(
      "fallback/" + [version_name, "no_image.png"].compact.join('_')
    )
  end


  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
