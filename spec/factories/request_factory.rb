# Request factory
FactoryGirl.define do
  PRIMO_REFERRER = 'info:sid/primo.exlibrisgroup.com:primo-'
  factory :request do
    sequence :session_id do |n| "session-#{n}" end
    referent
    trait :checked_out_referrer_id do
      referrer_id PrimoId::PRIMO_REFERRER_ID_BASE + PrimoId.new('checked out').id
    end
    trait :ill_referrer_id do
      referrer_id PrimoId::PRIMO_REFERRER_ID_BASE + PrimoId.new('ill').id
    end
    factory :checked_out_request, traits: [:checked_out_referrer_id]
    factory :ill_request, traits: [:ill_referrer_id]
  end
end
