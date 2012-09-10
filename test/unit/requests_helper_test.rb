require 'test_helper'
require 'requests_helper'
class RequestsHelperTest < ActiveSupport::TestCase
  fixtures :users, :requests, :referents, :referent_values
  setup :activate_authlogic
  include RequestsHelper

  def setup
    ServiceTypeValue.load_values!
    @primo_service = ServiceStore.instantiate_service!("NYU_Primo", nil)
    @primo_source_service = ServiceStore.instantiate_service!("NYU_Primo_Source", nil)
    activate_authlogic
    # @ba36_user_session = UserSession.create(users(:ba36))
    # @st75_user_session = UserSession.create(users(:st75))
    # @bobst_checked_out_record_request = requests(:primo_checked_out_request)
    @missing_user_stauses = ["18", "20", "84", "85", "86"]
    @missing_sub_libraries = ["BRES"]
  end
  
  test "instance_methods" do
    assert(respond_to?(:request_available?))
    assert(respond_to?(:request_recall?))
    assert(respond_to?(:request_offsite?))
    assert(respond_to?(:request_in_processing?))
    assert(respond_to?(:request_on_order?))
    assert(respond_to?(:request_ill?))
  end
  
  test "request_link_benchmarks" do
    request = requests(:primo_bobst_available_request)
    @primo_service.handle(request)
    request.service_responses.reload
    @primo_source_service.handle(request)
    request.service_responses.reload
    view_data = request.get_service_type('holding').first.view_data
    st75_user_session = UserSession.new(users(:st75))
    st75_user_session.save
    Benchmark.bmbm do |results|
      results.report("RequestsHelper#link_to_request?:") {
        (1..10).each {
          RequestsHelper.link_to_request?(view_data, st75_user_session)
        }
      }
    end
  end
  
  test "tnsgi_available_request_link" do
     request = requests(:primo_tnsgi_available_request)
     @primo_service.handle(request)
     request.service_responses.reload
     @primo_source_service.handle(request)
     request.service_responses.reload
     view_data = request.get_service_type('holding').first.view_data
     st75_user_session = UserSession.new(users(:st75))
     st75_user_session.save
     assert(!RequestsHelper.link_to_request?(view_data, st75_user_session),
       "While checking request available, st75 had an unexpected result for primo record, #{request.referent.metadata['primo']}.")
   end
   
   test "request_available?" do
     Exlibris::Aleph::TabHelper.instance.send(:sub_libraries).each_key do |sublibrary|
       next if @missing_sub_libraries.include?(sublibrary)
       expected_results_filename = "#{File.dirname(__FILE__)}/expected_results/#{sublibrary.downcase}_expected_results.yml"
       puts "\tNo expected results for #{sublibrary}." unless File.exists?(expected_results_filename)
       next unless File.exists?(expected_results_filename)
       expected_results_by_bor_status = YAML.load_file(expected_results_filename)
       begin
         request = requests("primo_#{sublibrary.downcase}_available_request".to_sym)
       rescue Exception => e
         puts "No available request for #{sublibrary}."
         next
       end 
       @primo_service.handle(request)
       request.service_responses.reload
       @primo_source_service.handle(request)
       request.service_responses.reload
       view_data = view_data(request, sublibrary)
       assert(!RequestsHelper.request_available?(view_data, nil),
         "While checking request available, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_recall?(view_data, nil),
         "While checking request recall, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_ill?(view_data, nil),
         "While checking request ill, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_in_processing?(view_data, nil),
         "While checking request in processing, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_offsite?(view_data, nil),
         "While checking request offsite, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       expected_results_by_bor_status.each { |bor_status, expected_results|
         next if @missing_user_stauses.include?(bor_status)
         user_session = UserSession.new(users(user_name(bor_status).to_sym)) 
         user_session.save
         assert(
           expected_results["available"] == 
             RequestsHelper.request_available?(view_data, user_session),
               "While checking request available, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.") unless expected_results["available"].nil?
         assert(!RequestsHelper.request_recall?(view_data, user_session),
           "While checking request recall, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(!RequestsHelper.request_ill?(view_data, user_session),
           "While checking request ill, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(!RequestsHelper.request_in_processing?(view_data, user_session),
           "While checking request in processing, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(!RequestsHelper.request_offsite?(view_data, user_session),
           "While checking request offsite, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       }
     end
   end
   
   test "request_recall?" do
     Exlibris::Aleph::TabHelper.instance.send(:sub_libraries).each_key do |sublibrary|
       next if @missing_sub_libraries.include?(sublibrary)
       expected_results_filename = "#{File.dirname(__FILE__)}/expected_results/#{sublibrary.downcase}_expected_results.yml"
       puts "\tNo expected results for #{sublibrary}." unless File.exists?(expected_results_filename)
       next unless File.exists?(expected_results_filename)
       expected_results_by_bor_status = YAML.load_file(expected_results_filename)
       begin
         request = requests("primo_#{sublibrary.downcase}_checked_out_request".to_sym)
       rescue Exception => e
         puts "No checked out request for #{sublibrary}."
         next
       end 
       @primo_service.handle(request)
       request.service_responses.reload
       @primo_source_service.handle(request)
       request.service_responses.reload
       view_data = view_data(request, sublibrary)
       assert(!RequestsHelper.request_available?(view_data, nil),
         "While checking request available, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_recall?(view_data, nil),
         "While checking request recall, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(RequestsHelper.request_ill?(view_data, nil),
         "While checking request ill, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_in_processing?(view_data, nil),
         "While checking request in processing, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_offsite?(view_data, nil),
         "While checking request offsite, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       expected_results_by_bor_status.each { |bor_status, expected_results|
         next if @missing_user_stauses.include?(bor_status)
         user_session = UserSession.new(users(user_name(bor_status).to_sym))
         user_session.save
         assert(!RequestsHelper.request_available?(view_data, user_session),
           "While checking request available, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(
           expected_results["recall"] == 
             RequestsHelper.request_recall?(view_data, user_session),
               "While checking request recall, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.") unless expected_results["recall"].nil?
         assert(RequestsHelper.request_ill?(view_data, user_session),
           "While checking request ill, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(!RequestsHelper.request_in_processing?(view_data, user_session),
           "While checking request in processing, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(!RequestsHelper.request_offsite?(view_data, user_session),
           "While checking request offsite, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       }
     end
   end
  
   test "request_recall_requested" do
       flunk("Implement test for requested items.")
   end
  
   test "request_ill?" do
     Exlibris::Aleph::TabHelper.instance.send(:sub_libraries).each_key do |sublibrary|
       next if @missing_sub_libraries.include?(sublibrary)
       expected_results_filename = "#{File.dirname(__FILE__)}/expected_results/#{sublibrary.downcase}_expected_results.yml"
       puts "\tNo expected results for #{sublibrary}." unless File.exists?(expected_results_filename)
       next unless File.exists?(expected_results_filename)
       expected_results_by_bor_status = YAML.load_file(expected_results_filename)
       begin
         request = requests("primo_#{sublibrary.downcase}_ill_request".to_sym)
       rescue Exception => e
         puts "No ill request for #{sublibrary}."
         next
       end 
       @primo_service.handle(request)
       request.service_responses.reload
       @primo_source_service.handle(request)
       request.service_responses.reload
       view_data = view_data(request, sublibrary)
       assert(!RequestsHelper.request_available?(view_data, nil),
         "While checking request available, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_recall?(view_data, nil),
         "While checking request recall, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(RequestsHelper.request_ill?(view_data, nil),
         "While checking request ill, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_in_processing?(view_data, nil),
         "While checking request in processing, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_offsite?(view_data, nil),
         "While checking request offsite, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       expected_results_by_bor_status.each { |bor_status, expected_results|
         next if @missing_user_stauses.include?(bor_status)
         user_session = UserSession.new(users(user_name(bor_status).to_sym))
         user_session.save
         assert(!RequestsHelper.request_available?(view_data, user_session),
           "While checking request available, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(!RequestsHelper.request_recall?(view_data, user_session),
           "While checking request recall, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(
           expected_results["ill"] == 
             RequestsHelper.request_ill?(view_data, user_session),
               "While checking request ill, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.") unless expected_results["ill"].nil?
         assert(!RequestsHelper.request_in_processing?(view_data, user_session),
           "While checking request in processing, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(!RequestsHelper.request_offsite?(view_data, user_session),
           "While checking request offsite, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       }
     end
   end
   
   test "request_in_processing?" do
     Exlibris::Aleph::TabHelper.instance.send(:sub_libraries).each_key do |sublibrary|
       next if @missing_sub_libraries.include?(sublibrary)
       expected_results_filename = "#{File.dirname(__FILE__)}/expected_results/#{sublibrary.downcase}_expected_results.yml"
       puts "\tNo expected results for #{sublibrary}." unless File.exists?(expected_results_filename)
       next unless File.exists?(expected_results_filename)
       expected_results_by_bor_status = YAML.load_file(expected_results_filename)
       begin
         request = requests("primo_#{sublibrary.downcase}_in_processing_request".to_sym)
       rescue Exception => e
         puts "No in processing request for #{sublibrary}."
         next
       end 
       @primo_service.handle(request)
       request.service_responses.reload
       @primo_source_service.handle(request)
       request.service_responses.reload
       view_data = view_data(request, sublibrary)
       assert(!RequestsHelper.request_available?(view_data, nil),
         "While checking request available, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_recall?(view_data, nil),
         "While checking request recall, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(RequestsHelper.request_ill?(view_data, nil),
         "While checking request ill, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(RequestsHelper.request_in_processing?(view_data, nil),
         "While checking request in processing, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_offsite?(view_data, nil),
         "While checking request offsite, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       expected_results_by_bor_status.each { |bor_status, expected_results|
         next if @missing_user_stauses.include?(bor_status)
         user_session = UserSession.new(users(user_name(bor_status).to_sym))
         user_session.save
         assert(!RequestsHelper.request_available?(view_data, user_session),
           "While checking request available, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(!RequestsHelper.request_recall?(view_data, user_session),
           "While checking request recall, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(RequestsHelper.request_ill?(view_data, user_session),
           "While checking request ill, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(
           expected_results["in_processing"] == 
             RequestsHelper.request_in_processing?(view_data, user_session),
               "While checking request in processing, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.") unless expected_results["in_processing"].nil?
         assert(!RequestsHelper.request_offsite?(view_data, user_session),
           "While checking request offsite, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       }
     end
   end
   
   test "request_offsite?" do
     Exlibris::Aleph::TabHelper.instance.send(:sub_libraries).each_key do |sublibrary|
       next if @missing_sub_libraries.include?(sublibrary)
       expected_results_filename = "#{File.dirname(__FILE__)}/expected_results/#{sublibrary.downcase}_expected_results.yml"
       puts "\tNo expected results for #{sublibrary}." unless File.exists?(expected_results_filename)
       next unless File.exists?(expected_results_filename)
       expected_results_by_bor_status = YAML.load_file(expected_results_filename)
       begin
         request = requests("primo_#{sublibrary.downcase}_offsite_request".to_sym)
       rescue Exception => e
         puts "No offsite request for #{sublibrary}."
         next
       end 
       @primo_service.handle(request)
       request.service_responses.reload
       @primo_source_service.handle(request)
       request.service_responses.reload
       view_data = view_data(request, sublibrary)
       assert(!RequestsHelper.request_available?(view_data, nil),
         "While checking request available, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_recall?(view_data, nil),
         "While checking request recall, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_ill?(view_data, nil),
         "While checking request ill, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(!RequestsHelper.request_in_processing?(view_data, nil),
         "While checking request in processing, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       assert(RequestsHelper.request_offsite?(view_data, nil),
         "While checking request offsite, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
       expected_results_by_bor_status.each { |bor_status, expected_results|
         next if @missing_user_stauses.include?(bor_status)
         user_session = UserSession.new(users(user_name(bor_status).to_sym))
         user_session.save
         assert(!RequestsHelper.request_available?(view_data, user_session),
           "While checking request available, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(!RequestsHelper.request_recall?(view_data, user_session),
           "While checking request recall, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(!RequestsHelper.request_ill?(view_data, user_session),
           "While checking request ill, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(!RequestsHelper.request_in_processing?(view_data, user_session),
           "While checking request in processing, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
         assert(
           expected_results["offsite"] == 
             RequestsHelper.request_offsite?(view_data, user_session),
               "While checking request offsite, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.") unless expected_results["offsite"].nil?
       }
     end
   end
   
  def user_session(bor_status)
    "#{user_name(bor_status)}_user_session"
  end
  
  def user_name(bor_status)
    "DS#{bor_status}D"
    return "st75"
  end
  
  def view_data(request, sublibrary)
    request.get_service_type('holding').each do |holding|
      return holding.view_data if holding.view_data[:library_code].eql? sublibrary
    end
    return {}
  end
end