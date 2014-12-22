# User factory
FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "developer#{n}"}
    email 'developer@example.com'
    firstname 'Dev'
    lastname 'Eloper'
    password_salt { Authlogic::Random.hex_token }
    crypted_password { Authlogic::CryptoProviders::Sha512.encrypt("#{username}#{password_salt}") }
    persistence_token { Authlogic::Random.hex_token }
    trait :nyu_aleph_attributes do
      user_attributes do
        {
          nyuidn: (ENV['BOR_ID'] || 'BOR_ID'),
          primary_institution: :NYU,
          institutions: [:NYU],
          bor_status: '51'
        }
      end
    end
    trait :cooper_union_aleph_attributes do
      user_attributes do
        {
          nyuidn: (ENV['BOR_ID'] || 'BOR_ID'),
          primary_institution: :CU,
          institutions: [:CU],
          bor_status: '10'
        }
      end
    end
    trait :ns_aleph_attributes do
      user_attributes do
        {
          nyuidn: (ENV['BOR_ID'] || 'BOR_ID'),
          primary_institution: :NS,
          institutions: [:NS],
          bor_status: '37'
        }
      end
    end
    factory :aleph_user, traits: [:nyu_aleph_attributes]
    factory :ezborrow_user, traits: [:nyu_aleph_attributes]
    factory :ill_user, traits: [:ns_aleph_attributes]
    factory :non_ezborrow_user, traits: [:cooper_union_aleph_attributes]
    factory :non_ill_user, traits: [:cooper_union_aleph_attributes]
  end
end
