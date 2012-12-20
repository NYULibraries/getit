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
    @missing_user_stauses = []
    @missing_sub_libraries = ["USR00", "HOME", "BOX", "ILLDT", "NYU51", "ALEPH", "USM50", 
      "MED", "HYL", "HIL", "LAM", "LAW", "LIT", "MUS", "WID", "EXL", "CIRC", "HILR", "HIL01", 
      "HYL01", "HYL02", "HYL03", "HYL04", "HYL05", "HYL06", "LAM01", "LAM02", "LAM03", "LAW01", 
      "LAW02", "LAW03", "LIT01", "LIT02", "MED01", "MED02", "MUS01", "MUS02", "WID01", "WID02", 
      "WID03", "WID04", "WID05", "U60WD", "U60HL", "U60LA", "U70WD", "CBAB", "BCU", "MBAZU", "USM51", 
      "ELEC5", "GDOC5", "EDUC5", "LINC5", "RRLIN", "OU511", "OR512", "OR513", "OR514", "OR515", "U61ED", 
      "U61EL", "U61LN", "S61GD", "USM53", "ELEC7", "GDOC7", "EDUC7", "LINC7", "USM54", "ELEC4", "USM55", 
      "CUN50", "CLEC5", "CDOC5", "CDUC5", "CINC5", "UNI50", "NARCV", "NELEC", "NRLEC", "NGDOC", "NRDOC", 
      "NEDUC", "NHLTH", "NLINC", "NLAW", "NMUSI", "NSCI", "NUPTN"]
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
    skip("Sydney left :(")
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
    skip("Need to identify legitimate available records.")
    no_user_assertions = {
      :available => false,
      :recall => false,
      :ill => false,
      :in_processing => false,
      :offsite => false
    }
    user_assertions = {
      :recall => false,
      :ill => false,
      :in_processing => false,
      :offsite => false
    }
    request_test("available", no_user_assertions, user_assertions)
  end

  test "request_recall?" do
    skip("Need to identify legitimate recall records.")
    no_user_assertions = {
      :available => false,
      :recall => false,
      :ill => true,
      :in_processing => false,
      :offsite => false
    }
    user_assertions = {
      :available => false,
      :ill => true,
      :in_processing => false,
      :offsite => false
    }
    request_test("recall", no_user_assertions, user_assertions)
  end

  test "request_recall_requested" do
   skip
   flunk("Implement test for requested items.")
  end

  test "request_ill?" do
    skip("Need to identify legitimate ILL records.")
    no_user_assertions = {
      :available => false,
      :recall => false,
      :ill => true,
      :in_processing => false,
      :offsite => false
    }
    user_assertions = {
      :available => false,
      :recall => true,
      :in_processing => false,
      :offsite => false
    }
    request_test("ill", no_user_assertions, user_assertions)
  end

  test "request_in_processing?" do
    skip("Need to identify legitimate in processing records.")
    no_user_assertions = {
      :available => false,
      :recall => false,
      :ill => true,
      :in_processing => true,
      :offsite => false
    }
    user_assertions = {
      :available => false,
      :recall => false,
      :ill => true,
      :offsite => false
    }
    request_test("in_processing", no_user_assertions, user_assertions)
  end

  test "request_offsite?" do
    skip("Need to identify legitimate offsite records.")
      :available => false,
      :recall => false,
      :ill => false,
      :in_processing => false,
      :offsite => true
    }
    user_assertions = {
      :available => false,
      :recall => false,
      :ill => false,
      :in_processing => false
    }
    request_test("offsite", no_user_assertions, user_assertions)
  end

  private
  def request_test(testing_request_type, no_user_assertions, user_assertions) 
    # For each sublibrary run the set of tests.
    Exlibris::Aleph::TabHelper.instance.send(:sub_libraries).each_key do |sublibrary|
      # If we explicitly skip a sublibrary, go to the next one.
      # Useful for default ExLibris sublibraries
      next if @missing_sub_libraries.include?(sublibrary)
      expected_results_filename = "#{File.dirname(__FILE__)}/expected_results/#{sublibrary.downcase}_expected_results.yml"
      puts "No expected results for #{sublibrary}." unless File.exists?(expected_results_filename)
      next unless File.exists?(expected_results_filename)
      expected_results_by_bor_status = YAML.load_file(expected_results_filename)
      begin
        request = requests("primo_#{sublibrary.downcase}_#{testing_request_type}_request".to_sym)
      rescue Exception => e
        puts "No #{testing_request_type} request for #{sublibrary}."
        next
      end 
      @primo_service.handle(request)
      request.service_responses.reload
      @primo_source_service.handle(request)
      request.service_responses.reload
      view_data = view_data(request, sublibrary)
      RequestsHelper.request_types.each do |request_type|
        next if no_user_assertions[request_type.to_sym].nil?
        assert(no_user_assertions[request_type.to_sym].eql?(requestable?(request_type, view_data)),
          "While checking request #{request_type}, nil user had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
      end
      expected_results_by_bor_status.each { |bor_status, expected_results|
        next if @missing_user_stauses.include?(bor_status)
        user_session = UserSession.new(users(user_name(bor_status).to_sym)) 
        user_session.save
        RequestsHelper.request_types.each do |request_type|
          assertion = (expected_results["#{request_type}"].nil?) ? 
            true : (request_type.eql?(testing_request_type)) ? 
              (expected_results["#{request_type}"].eql?(requestable?(request_type, view_data, user_session))) :
                user_assertions[request_type.to_sym].eql?(requestable?(request_type, view_data, user_session))
          assert(assertion,
            "While checking request #{request_type}, borrower status #{bor_status} had an unexpected result in #{sublibrary} for primo record, #{request.referent.metadata['primo']}.")
        end
      }
    end
  end
  
  def requestable?(request_type, view_data, user_session=nil)
    RequestsHelper.send("request_#{request_type}?".to_sym, view_data, user_session)
  end

  def user_session(bor_status)
    "#{user_name(bor_status)}_user_session"
  end
  
  def user_name(bor_status)
    return "DS#{bor_status}D"
  end
  
  def view_data(request, sublibrary)
    request.get_service_type('holding').each do |holding|
      return holding.view_data if holding.view_data[:library_code].eql? sublibrary
    end
    return {}
  end
end