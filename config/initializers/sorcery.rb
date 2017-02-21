# frozen_string_literal: true
# The first thing you need to configure is which modules you need in your app.
# The default is nothing which will include only core features
# (password encryption, login/logout).
# Available submodules are: :user_activation, :http_basic_auth, :remember_me,
# :reset_password, :session_timeout, :brute_force_protection,
# :activity_logging, :external
Rails.application.config.sorcery.submodules = [:external]

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|

  # -- external --
  # What providers are supported by this app, i.e. [:twitter, :facebook, :github,
  # :linkedin, :xing, :google, :liveid, :salesforce, :slack] .
  # Default: `[]`
  #
  config.external_providers = [:twitter, :facebook, :vk]

  # You can change it by your local ca_file. i.e. '/etc/pki/tls/certs/ca-bundle.crt'
  # Path to ca_file. By default use a internal ca-bundle.crt.
  # Default: `'path/to/ca_file'`
  #
  # config.ca_file =

  # Twitter will not accept any requests nor redirect uri containing localhost,
  # make sure you use 0.0.0.0:3000 to access your app in development
  #

  config.facebook.key = ENV["FACEBOOK_KEY"]
  config.facebook.secret = ENV["FACEBOOK_SECRET"]
  config.facebook.callback_url = ENV["FACEBOOK_CALLBACK_URL"]
  config.facebook.user_info_mapping = { email: "name" }
  config.facebook.access_permissions = ["email"]
  config.facebook.display = "page"
  config.facebook.api_version = "v2.2"

  # --- user config ---
  config.user_config do |user|

    # -- external --
    # Class which holds the various external provider data for this user.
    # Default: `nil`
    #
    user.authentications_class = Authentication
  end

  # This line must come after the 'user config' block.
  # Define which model authenticates with sorcery.
  config.user_class = 'User'
end
