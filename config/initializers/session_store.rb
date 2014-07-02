# Be sure to restart your server when you modify this file.
Rails.application.config.session_store ActionDispatch::Session::CacheStore,
  key: '_getit_session', domain: '.library.nyu.edu', compress: true

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# GetIt::Application.config.session_store :active_record_store
