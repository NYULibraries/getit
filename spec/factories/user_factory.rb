# User factory
FactoryGirl.define do
  factory :user do
    sequence :username do |n| "user#{n}" end
    email { "#{username}@example.com" }
    firstname 'Dev'
    lastname 'Eloper'
    institution_code 'NYU'
    aleph_id { (ENV['BOR_ID'] || 'BOR_ID') }
    provider 'nyu_shibboleth'
    trait :nyu_aleph_attributes do
      patron_status '51'
    end
    trait :cooper_union_aleph_attributes do
      patron_status '10'
    end
    trait :ns_aleph_attributes do
      patron_status '37'
    end
    factory :aleph_user, traits: [:nyu_aleph_attributes]
    factory :ezborrow_user, traits: [:nyu_aleph_attributes]
    factory :ill_user, traits: [:ns_aleph_attributes]
    factory :non_ezborrow_user, traits: [:cooper_union_aleph_attributes]
    factory :non_ill_user, traits: [:cooper_union_aleph_attributes]
  end
end
