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
          status: 'Request ILL'
          requestability: 'yes'
        }
      end
    end
    factory :checked_out_service_response, traits: [:primo_source, :checked_out]
    factory :ill_service_response, traits: [:primo_source, :ill]
  end
end
