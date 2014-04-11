# ServiceResponse factory
FactoryGirl.define do
  factory :service_response do
    service_id 'NYU_SFX'
    display_text 'Dummy Service'
    url 'http://www.example.com'
    notes 'Some notes'
    service_data do
      {
        source_data: { },
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
          source_data: { sub_library_code: 'BOBST' },
          status_code: 'requested',
          status: 'Requested',
          requestability: 'yes'
        }
      end
    end
    trait :available do
      service_data do
        {
          source_data: {
            adm_library_code: 'NYU50',
            sub_library_code: 'BOBST'
          },
          status_code: 'available',
          status: 'Available',
          requestability: 'deferred'
        }
      end
    end
    trait :checked_out do
      service_data do
        {
          source_data: { sub_library_code: 'BOBST' },
          status_code: 'checked_out',
          status: 'Due: 01/31/13',
          requestability: 'yes'
        }
      end
    end
    trait :ill do
      service_data do
        {
          source_data: { sub_library_code: 'BOBST' },
          status_code: 'ill',
          status: 'Request ILL',
          requestability: 'yes'
        }
      end
    end
    trait :on_order do
      service_data do
        {
          source_data: { sub_library_code: 'BOBST' },
          status_code: 'check_holdings',
          status: 'On Order',
          requestability: 'yes'
        }
      end
    end
    trait :billed_as_lost do
      service_data do
        {
          source_data: { sub_library_code: 'BOBST' },
          status_code: 'billed_as_lost',
          status: 'Request ILL',
          requestability: 'yes'
        }
      end
    end
    trait :requested do
      service_data do
        {
          source_data: { sub_library_code: 'BOBST' },
          status_code: 'requested',
          status: 'Requested',
          requestability: 'yes'
        }
      end
    end
    trait :offsite do
      service_data do
        {
          source_data: { sub_library_code: 'BOBST' },
          status_code: 'offsite',
          status: 'Offsite Available',
          requestability: 'yes'
        }
      end
    end
    trait :processing do
      service_data do
        {
          source_data: { sub_library_code: 'BOBST' },
          status_code: 'processing',
          status: 'In Processing',
          requestability: 'yes'
        }
      end
    end
    trait :afc_recalled do
      service_data do
        {
          source_data: {
            adm_library_code: 'NYU50',
            sub_library_code: 'BAFC'
          },
          status_code: 'recalled',
          status: 'Due: 01/01/14',
          requestability: 'deferred'
        }
      end
    end
    trait :bobst_recalled do
      service_data do
        {
          source_data: { sub_library_code: 'BOBST' },
          status_code: 'recalled',
          status: 'Due: 01/01/14',
          requestability: 'deferred'
        }
      end
    end
    trait :deferred_requestability do
      service_data do
        {
          source_data: { sub_library_code: 'BOBST' },
          status_code: 'available',
          status: 'Available',
          requestability: 'deferred'
        }
      end
    end
    trait :always_requestable do
      service_data do
        {
          source_data: { sub_library_code: 'BOBST' },
          status_code: 'checked_out',
          status: 'Due: 01/31/13',
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
    factory :afc_recalled_service_response, traits: [:primo_source, :afc_recalled]
    factory :bobst_recalled_service_response, traits: [:primo_source, :bobst_recalled]
    factory :deferred_requestability_service_response, traits: [:primo_source, :deferred_requestability]
    factory :always_requestable_service_response, traits: [:primo_source, :always_requestable]
  end
end
