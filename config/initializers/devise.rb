# frozen_string_literal: true

Devise.setup do |config|
  # Configure the mailer sender address
  # config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  # config/initializers/devise.rb
  config.mailer = "CustomDeviseMailer"
  config.mailer_sender = "your-email@example.com"  # Set this to your email address



  # Configure ORM (active_record for database-based authentication)
  require "devise/orm/active_record"

  # Configure the JWT authentication settings
  config.jwt do |jwt|
    # Set the secret key for encoding and decoding the JWT token
    jwt.secret = Rails.application.credentials.fetch(:secret_key_base)

    # Specify the routes that will trigger JWT token issuance (dispatch)
    jwt.dispatch_requests = [
      [ "POST", %r{^/login$} ]  # Token issued on login
    ]

    # Specify routes that will revoke (invalidate) the JWT token
    jwt.revocation_requests = [
      [ "DELETE", %r{^/logout$} ]  # Token revoked on logout
    ]

    # Set expiration time for the JWT token
    jwt.expiration_time = 30.minutes.to_i
  end

  # Other Devise configurations

  # Authentication keys, here it's assuming :email for authentication
  config.authentication_keys = [ :email ]

  # Ensure the JWT token is stored in headers on API requests
  config.skip_session_storage = [ :http_auth ]

  # Configure which authentication keys should be case-insensitive
  config.case_insensitive_keys = [ :email ]

  # Configure password length, making it more secure by default
  config.password_length = 6..128

  # Enable or disable rememberable settings for persistent sessions
  config.remember_for = 2.weeks

  # Expire remember_me tokens when user logs out
  config.expire_all_remember_me_on_sign_out = true

  # Configure confirmable settings if needed
  config.reconfirmable = true

  # Configure token expiration times for password recovery and other features
  config.reset_password_within = 6.hours

  # Enable default configuration for CSRF token handling on API calls
  config.clean_up_csrf_token_on_authentication = true

  # Set up navigation formats for APIs, commonly used in API responses
  config.navigational_formats = []

  # Use other features as needed based on your application
end
