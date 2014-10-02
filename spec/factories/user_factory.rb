# User factory
FactoryGirl.define do
  factory :user do
    sequence :username do |n| "user#{n}" end
    provider 'nyu_shibboleth'
    email { "#{username}@example.com" }
    firstname 'Dev'
    lastname 'Eloper'
    institution_code 'NYU'
    aleph_id { (ENV['BOR_ID'] || 'BOR_ID') }
    trait :nyu_aleph_attributes do
    end
    trait :cooper_union_aleph_attributes do
    end
    factory :aleph_user, traits: [:nyu_aleph_attributes]
    factory :ezborrow_user, traits: [:nyu_aleph_attributes]
    factory :non_ezborrow_user, traits: [:cooper_union_aleph_attributes]
  end
end
