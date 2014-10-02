# User factory
FactoryGirl.define do
  factory :user do
    username 'developer'
    email 'developer@example.com'
    firstname 'Dev'
    lastname 'Eloper'
    trait :aleph_attributes do
      user_attributes do
        {
          nyuidn: (ENV['BOR_ID'] || 'BOR_ID'),
          primary_institution: :NYU,
          institutions: [:NYU],
          bor_status: '51'
        }
      end
    end
    factory :aleph_user, traits: [:aleph_attributes]
  end
end
