# Be sure to restart your server when you modify this file.

if ENV['LOGIN_COOKIE_DOMAIN'].present? && !Rails.env.test?
  Rails.application.config.session_store :cookie_store, key: '_get_it_session', domain: ENV['LOGIN_COOKIE_DOMAIN']
else
  Rails.application.config.session_store :cookie_store, key: '_get_it_session'
end
