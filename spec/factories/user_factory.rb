# User factory
FactoryGirl.define do
  factory :user do
    username 'developer'
    email 'developer@example.com'
    firstname 'Dev'
    lastname 'Eloper'
    password_salt Authlogic::Random.hex_token
    crypted_password { Authlogic::CryptoProviders::Sha512.encrypt("#{username}#{password_salt}") }
    persistence_token Authlogic::Random.hex_token
    user_attributes do
      {
        nyuidn: 'BOR_ID',
        verification: 'VERIFICATION',
        primary_institution: :NYU,
        institutions: [:NYU],
        bor_status: '51'
      }
    end
    trait :hold_permissions do
    end
  end
end
