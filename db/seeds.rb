# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Set up a development user
require 'authlogic'
username = 'dev123'
if Rails.env.development? and User.find_by_username(username).nil?
  salt = Authlogic::Random.hex_token
  user = User.create!({
    username: username,
    firstname: 'Dev',
    lastname: 'Eloper',
    email: 'dev.eloper@library.edu',
    password_salt: salt,
    crypted_password: Authlogic::CryptoProviders::Sha512.encrypt(username + salt),
    persistence_token: Authlogic::Random.hex_token,
  })
  user.user_attributes = {
    nyuidn: (ENV['BOR_ID'] || 'BOR_ID'),
    primary_institution: :NYU,
    institutions: [:NYU],
    bor_status: '51'
  }
  user.save!
end
