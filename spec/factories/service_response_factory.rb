# ServiceResponse factory
FactoryGirl.define do
  factory :service_response do
    service_id 'DummyService'
    display_text 'Dummy Service'
    url 'http://www.example.com'
    notes 'Some notes'
    service_data do
      {
        key1: 'value1',
        key2: 'value1'
      }
    end
    service_type_value_name 'holding'
    request
    trait :fulltext do
      service_type_value_name 'fulltext'
    end
    trait :primo_service do
      service_id 'NYU_Primo'
    end
    trait :primo_source do
      service_id 'NYU_Primo_Source'
    end
    trait :requested do
      service_data do
        {
          status_code: 'requested',
          status: 'Requested',
          requestability: 'yes'
        }
      end
    end
    trait :available do
      service_data do
        {
          status_code: 'available',
          status: 'Available',
          requestability: 'deferred'
        }
      end
    end
    trait :checked_out do
      service_data do
        {
          status_code: 'checked_out',
          status: 'Due: 01/31/13',
          requestability: 'yes'
        }
      end
    end
    trait :ill do
      service_data do
        {
          status_code: 'ill',
          status: 'Request ILL',
          requestability: 'yes'
        }
      end
    end
    trait :on_order do
      service_data do
        {
          status_code: 'check_holdings',
          status: 'On Order',
          requestability: 'yes'
        }
      end
    end
    trait :billed_as_lost do
      service_data do
        {
          status_code: 'billed_as_lost',
          status: 'Request ILL',
          requestability: 'yes'
        }
      end
    end
    trait :requested do
      service_data do
        {
          status_code: 'requested',
          status: 'Requested',
          requestability: 'yes'
        }
      end
    end
    trait :offsite do
      service_data do
        {
          status_code: 'offsite',
          status: 'Offsite Available',
          requestability: 'yes'
        }
      end
    end
    trait :processing do
      service_data do
        {
          status_code: 'processing',
          status: 'In Processing',
          requestability: 'yes'
        }
      end
    end
    factory :ill_service_response, traits: [:primo_source, :ill]
    factory :billed_as_lost_service_response, traits: [:primo_source, :billed_as_lost]
    factory :requested_service_response, traits: [:primo_source, :requested]
    factory :on_order_service_response, traits: [:primo_source, :on_order]
    factory :checked_out_service_response, traits: [:primo_source, :checked_out]
    factory :available_service_response, traits: [:primo_source, :available]
    factory :offsite_service_response, traits: [:primo_source, :offsite]
    factory :processing_service_response, traits: [:primo_source, :processing]
  end
end
