# frozen_string_literal: true
require 'support/authentication'

RSpec.configure do |config|
  config.include Sorcery::TestHelpers::Rails::Controller, type: :controller
  #config.include Sorcery::TestHelpers::Rails::Integration, type: :feature
  config.include AuthenticationForFeatureSpecs, type: :feature
end
