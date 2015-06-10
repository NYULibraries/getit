# User factory
FactoryGirl.define do
  factory :user do
    sequence :username do |n| "user#{n}" end
    email { "#{username}@example.com" }
    firstname 'Dev'
    lastname 'Eloper'
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
    factory :afc_user, traits: [:cooper_union_aleph_attributes]
    factory :non_afc_user, traits: [:ns_aleph_attributes]
  end
end
