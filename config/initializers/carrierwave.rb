# frozen_string_literal: true
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

CarrierWave.configure do |config|
  config.fog_provider    = 'fog/aws'                     # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],     # required
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], # required
    region:                ENV['AWS_REGION'],
  }
  config.fog_directory  = ENV['AWS_BUCKET']              # required
  config.fog_public     = false                          # optional, defaults to true
  config.fog_attributes =
    { 'Cache-Control' => "max-age=#{365.days.to_i}" }    # optional, defaults to {}
end
