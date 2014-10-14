# ServiceResponse factory
def nyu_aleph_status(circulation_status_value)
  circulation_status =
    Exlibris::Aleph::Item::CirculationStatus.new(circulation_status_value)
  Exlibris::Nyu::Aleph::Status.new(circulation_status)
end

def reserves_status(circulation_status_value, status_code, status_display)
  item_status = Exlibris::Aleph::Item::Status.new(status_code, status_display)
  Exlibris::Nyu::Aleph::ReservesStatus.new(nyu_aleph_status('Available'), item_status)
end

admin_library = Exlibris::Aleph::AdminLibrary.new('NYU50')
sub_library = Exlibris::Aleph::SubLibrary.new('BOBST', 'NYU Bobst', admin_library)
collection = Exlibris::Aleph::Collection.new('MAIN', 'Main Collection', sub_library)
call_number = Exlibris::Aleph::Item::CallNumber.new('DS126 .M62 2002', nil)
nyu_call_number = Exlibris::Nyu::Aleph::CallNumber.new(call_number)

nyu_aleph_service_data = {
  record_id: 'nyu_aleph000741245',
  original_id: 'nyu_aleph000741245',
  title: 'An aesthetic occupation : the immediacy of architecture and the Palestine conflict',
  author: 'Daniel Bertrand  Monk  1960-',
  display_type: 'book',
  source_id: 'nyu_aleph',
  original_source_id: 'NYU01',
  source_record_id: '000741245',
  ils_api_id: 'NYU01000741245',
  institution_code: 'NYU',
  institution: 'NYU',
  library_code: 'BOBST',
  library: sub_library,
  collection: collection,
  call_number: nyu_call_number,
  coverage: [],
  status: nyu_aleph_status('05/27/14'),
  from_aleph: true,
  requestability: 'deferred',
  collection_str: 'NYU Bobst Main Collection',
  coverage_str: '',
  edition_str: '',
  coverage_str_array: [],
  match_reliability: "exact",
  source_data: {
    item_id: 'NYU50000741245000010',
    doc_library: 'NYU01',
    sub_library_code: 'BOBST',
    sub_library: sub_library,
    collection: collection,
    call_number: nyu_call_number,
    doc_number: '000741245',
    rest_api_id: 'NYU01000741245'
  }
}

FactoryGirl.define do
  factory :service_response do
    service_id 'NYU_SFX'
    display_text 'Dummy Service'
    url 'http://www.example.com'
    notes 'Some notes'
    service_data do
      {
        key1: 'value1',
        key2: 'value1'
      }
    end
    service_type_value_name 'fulltext'
    request

    trait :holding do
      service_type_value_name 'holding'
      service_data do
        {
          collection_str: "NYU Bobst Main Collection",
          call_number: "(DS126 .M62 2002 )",
          coverage: [],
          status: "Check Availability",
          edition_str: '',
          match_reliability: "exact"
        }
      end
    end

    trait :primo do
      service_id 'NYU_Primo'
    end

    trait :primo_source do
      service_id 'NYU_Primo_Source'
    end

    trait :nyu_aleph_without_source_data do
      service_data do
        nyu_aleph_service_data.reject do |key, value|
          key == :source_data
        end
      end
    end

    trait :nyu_aleph do
      service_data do
        nyu_aleph_service_data
      end
    end

    trait :nyu_aleph_not_from_aleph do
      service_data do
        nyu_aleph_service_data.merge({from_aleph: false, status: 'Check Availability'})
      end
    end

    trait :expired_nyu_aleph do
      service_data do
        nyu_aleph_service_data.merge({expired: true})
      end
    end

    trait :single_pickup_location_nyu_aleph do
      item_hash = {item_id: 'NYU50000741245000020'}
      single_pickup_location_source_data =
        nyu_aleph_service_data[:source_data].merge(item_hash)
      service_data do
        nyu_aleph_service_data.merge(source_data: single_pickup_location_source_data)
      end
    end

    trait :abu_dhabi_nyu_aleph do
      abu_dhabi_admin_library = Exlibris::Aleph::AdminLibrary.new('NYU51')
      abu_dhabi_sub_library = Exlibris::Aleph::SubLibrary.new('NABUD', 'NYU Abu Dhabi Library (UAE)', abu_dhabi_admin_library)
      service_data do
        nyu_aleph_service_data.merge({library: abu_dhabi_sub_library})
      end
    end

    trait :bobst_reserve_nyu_aleph do
      bobst_reserve_sub_library = Exlibris::Aleph::SubLibrary.new('BRES', 'NYU Bobst Reserve Collection', admin_library)
      status = reserves_status('On Shelf', '20', 'Reserve 2 hour loan')
      requestability = 'deferred'
      service_data do
        nyu_aleph_service_data.merge({library: bobst_reserve_sub_library, status: status, requestability: requestability})
      end
    end

    trait :avery_fisher_nyu_aleph do
      avery_fisher_sub_library = Exlibris::Aleph::SubLibrary.new('BAFC', 'NYU Bobst Avery Fisher Center', admin_library)
      service_data do
        nyu_aleph_service_data.merge({library: avery_fisher_sub_library})
      end
    end

    trait :on_shelf_nyu_aleph do
      status = nyu_aleph_status('On Shelf')
      requestability = 'deferred'
      status_hash = {status: status, requestability: requestability}
      service_data do
        nyu_aleph_service_data.merge(status_hash)
      end
    end

    trait :available_nyu_aleph do
      status = nyu_aleph_status('Available')
      requestability = 'deferred'
      status_hash = {status: status, requestability: requestability}
      service_data do
        nyu_aleph_service_data.merge(status_hash)
      end
    end

    trait :checked_out_nyu_aleph do
      status = nyu_aleph_status('06/28/14')
      requestability = 'yes'
      status_hash = {status: status, requestability: requestability}
      service_data do
        nyu_aleph_service_data.merge(status_hash)
      end
    end

    trait :billed_as_lost_nyu_aleph do
      status = nyu_aleph_status('Billed as Lost')
      requestability = 'yes'
      status_hash = {status: status, requestability: requestability}
      service_data do
        nyu_aleph_service_data.merge(status_hash)
      end
    end

    trait :claimed_returned_nyu_aleph do
      status = nyu_aleph_status('Claimed Returned')
      requestability = 'yes'
      status_hash = {status: status, requestability: requestability}
      service_data do
        nyu_aleph_service_data.merge(status_hash)
      end
    end

    trait :reshelving_nyu_aleph do
      status = nyu_aleph_status('Reshelving')
      requestability = 'deferred'
      status_hash = {status: status, requestability: requestability}
      service_data do
        nyu_aleph_service_data.merge(status_hash)
      end
    end

    trait :ill_nyu_aleph do
      status = nyu_aleph_status('Request ILL')
      requestability = 'deferred'
      status_hash = {status: status, requestability: requestability}
      service_data do
        nyu_aleph_service_data.merge(status_hash)
      end
    end

    trait :processing_nyu_aleph do
      status = nyu_aleph_status('In Processing')
      requestability = 'deferred'
      status_hash = {status: status, requestability: requestability}
      service_data do
        nyu_aleph_service_data.merge(status_hash)
      end
    end

    trait :transit_nyu_aleph do
      status = nyu_aleph_status('In Transit')
      requestability = 'deferred'
      status_hash = {status: status, requestability: requestability}
      service_data do
        nyu_aleph_service_data.merge(status_hash)
      end
    end

    trait :on_order_nyu_aleph do
      status = nyu_aleph_status('On Order')
      requestability = 'deferred'
      status_hash = {status: status, requestability: requestability}
      service_data do
        nyu_aleph_service_data.merge(status_hash)
      end
    end

    trait :offsite_nyu_aleph do
      status = nyu_aleph_status('Offsite Available')
      requestability = 'deferred'
      status_hash = {status: status, requestability: requestability}
      service_data do
        nyu_aleph_service_data.merge(status_hash)
      end
    end

    trait :requested_nyu_aleph do
      status = nyu_aleph_status('Requested')
      requestability = 'deferred'
      status_hash = {status: status, requestability: requestability}
      service_data do
        nyu_aleph_service_data.merge(status_hash)
      end
    end

    factory :holding_service_response, traits: [:holding]
    factory :primo_service_response, traits: [:holding, :primo]
    factory :primo_source_service_response, traits: [:holding, :primo_source]
    factory :nyu_aleph_service_response_without_source_data, traits: [:holding, :primo_source, :nyu_aleph_without_source_data]
    factory :nyu_aleph_not_from_aleph_service_response, traits: [:holding, :primo_source, :nyu_aleph_not_from_aleph]
    factory :nyu_aleph_service_response, traits: [:holding, :primo_source, :nyu_aleph]
    factory :expired_nyu_aleph_service_response, traits: [:holding, :primo_source, :expired_nyu_aleph]
    factory :single_pickup_location_nyu_aleph_service_response, traits: [:holding, :primo_source, :single_pickup_location_nyu_aleph]
    factory :abu_dhabi_nyu_aleph_service_response, traits: [:holding, :primo_source, :abu_dhabi_nyu_aleph]
    factory :bobst_reserve_nyu_aleph_service_response, traits: [:holding, :primo_source, :bobst_reserve_nyu_aleph]
    factory :avery_fisher_nyu_aleph_service_response, traits: [:holding, :primo_source, :avery_fisher_nyu_aleph]
    factory :on_shelf_nyu_aleph_service_response, traits: [:holding, :primo_source, :on_shelf_nyu_aleph]
    factory :available_nyu_aleph_service_response, traits: [:holding, :primo_source, :available_nyu_aleph]
    factory :checked_out_nyu_aleph_service_response, traits: [:holding, :primo_source, :checked_out_nyu_aleph]
    factory :billed_as_lost_nyu_aleph_service_response, traits: [:holding, :primo_source, :billed_as_lost_nyu_aleph]
    factory :claimed_returned_nyu_aleph_service_response, traits: [:holding, :primo_source, :claimed_returned_nyu_aleph]
    factory :reshelving_nyu_aleph_service_response, traits: [:holding, :primo_source, :reshelving_nyu_aleph]
    factory :ill_nyu_aleph_service_response, traits: [:holding, :primo_source, :ill_nyu_aleph]
    factory :processing_nyu_aleph_service_response, traits: [:holding, :primo_source, :processing_nyu_aleph]
    factory :transit_nyu_aleph_service_response, traits: [:holding, :primo_source, :transit_nyu_aleph]
    factory :on_order_nyu_aleph_service_response, traits: [:holding, :primo_source, :on_order_nyu_aleph]
    factory :offsite_nyu_aleph_service_response, traits: [:holding, :primo_source, :offsite_nyu_aleph]
    factory :requested_nyu_aleph_service_response, traits: [:holding, :primo_source, :requested_nyu_aleph]
  end

  # factory :nyu_aleph_service_response, class: ServiceResponse do
  #   service_id 'NYU_Primo_Source'
  #   service_data do
  #     nyu_aleph_service_data
  #   end
  #   trait :requested do
  #     service_data do
  #       nyu_aleph_service_data
  #     end
  #   end
  #   trait :available_service_data do
  #     service_data do
  #       {
  #         status: 'Available',
  #         requestability: 'deferred'
  #       }
  #     end
  #   end
  #   trait :checked_out do
  #     service_data do
  #       {
  #         status: 'Due: 01/31/13',
  #         requestability: 'yes'
  #       }
  #     end
  #   end
  #   trait :ill do
  #     service_data do
  #       {
  #         status: 'Request ILL',
  #         requestability: 'yes'
  #       }
  #     end
  #   end
  #   trait :on_order do
  #     service_data do
  #       {
  #         status: 'On Order',
  #         requestability: 'yes'
  #       }
  #     end
  #   end
  #   trait :billed_as_lost do
  #     service_data do
  #       {
  #         status: 'Request ILL',
  #         requestability: 'yes'
  #       }
  #     end
  #   end
  #   trait :requested do
  #     service_data do
  #       {
  #         status: 'Requested',
  #         requestability: 'yes'
  #       }
  #     end
  #   end
  #   trait :offsite do
  #     service_data do
  #       {
  #         status: 'Offsite Available',
  #         requestability: 'yes'
  #       }
  #     end
  #   end
  #   trait :processing do
  #     service_data do
  #       {
  #         status: 'In Processing',
  #         requestability: 'yes'
  #       }
  #     end
  #   end
  #   trait :afc_recalled do
  #     service_data do
  #       {
  #         status: 'Due: 01/01/14',
  #         requestability: 'deferred'
  #       }
  #     end
  #   end
  #   trait :bobst_recalled do
  #     service_data do
  #       {
  #         status: 'Due: 01/01/14',
  #         requestability: 'deferred'
  #       }
  #     end
  #   end
  #   trait :deferred_requestability do
  #     service_data do
  #       {
  #         status: 'Available',
  #         requestability: 'deferred'
  #       }
  #     end
  #   end
  #   trait :always_requestable do
  #     service_data do
  #       {
  #         status: 'Due: 01/31/13',
  #         requestability: 'yes'
  #       }
  #     end
  #   end
  #   trait :never_requestable do
  #     service_data do
  #       {
  #         status: 'Reshelving',
  #         requestability: 'no'
  #       }
  #     end
  #   end
  #   factory :ill_service_response, traits: [:ill]
  #   factory :billed_as_lost_service_response, traits: [:billed_as_lost]
  #   factory :requested_service_response, traits: [:requested]
  #   factory :on_order_service_response, traits: [:on_order]
  #   factory :checked_out_service_response, traits: [:checked_out]
  #   factory :available_service_response, traits: [:available]
  #   factory :offsite_service_response, traits: [:offsite]
  #   factory :processing_service_response, traits: [:processing]
  #   factory :afc_recalled_service_response, traits: [:afc_recalled]
  #   factory :bobst_recalled_service_response, traits: [:bobst_recalled]
  #   factory :deferred_requestability_service_response, traits: [:deferred_requestability]
  #   factory :always_requestable_service_response, traits: [:always_requestable]
  #   factory :never_requestable_service_response, traits: [:never_requestable]
  # end
end
