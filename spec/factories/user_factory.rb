# User factory
FactoryGirl.define do
  factory :user do
    sequence :username do |n| "user#{n}" end
    provider 'nyu_shibboleth'
    email { "#{username}@example.com" }
    firstname 'Dev'
    lastname 'Eloper'
    institution_code 'NYU'
    trait :aleph_attributes do
      aleph_id { (ENV['BOR_ID'] || 'BOR_ID') }
    end
    factory :aleph_user, traits: [:aleph_attributes]
  end
end
