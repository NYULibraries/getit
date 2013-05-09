# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Set up a development user
require 'authlogic'
user_seeds = Settings.seeds.user
username = user_seeds.username
if Rails.env.development? and User.find_by_username(username).nil?
  salt = Authlogic::Random.hex_token
  user = User.create!({
    username: username, 
    firstname: user_seeds.firstname, 
    lastname: user_seeds.lastname, 
    email: user_seeds.email,
    password_salt: salt,
    crypted_password: Authlogic::CryptoProviders::Sha512.encrypt(username + salt),
    persistence_token: Authlogic::Random.hex_token,
  })
  user.user_attributes = {
    nyuidn: user_seeds.nyuidn, verification: user_seeds.verification,
    primary_institution: user_seeds.primary_institution.to_sym,
    institutions: user_seeds.institutions.collect{|institution| institution.to_sym},
    bor_status: user_seeds.bor_status
  }
  user.save!
end
