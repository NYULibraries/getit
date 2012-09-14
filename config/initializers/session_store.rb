# Be sure to restart your server when you modify this file.
require 'action_dispatch/middleware/session/dalli_store' 
Umlaut3::Application.config.session_store :dalli_store, key: '_umlaut3_session', 
  :memcache_server => '127.0.0.1:11211', 
  :namespace => 'sessions', 
  :key => '_umlaut3_session', 
  :expire_after => 24.hours


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Umlaut3::Application.config.session_store :active_record_store
