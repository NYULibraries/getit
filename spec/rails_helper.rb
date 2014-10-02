# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
# Wear merged coveralls for rails
require 'coveralls'
Coveralls.wear_merged!('rails')

require 'exlibris-nyu'
# Use the included test mnt for testing.
Exlibris::Aleph.configure do |config|
  config.table_path = "#{File.dirname(__FILE__)}/../test/mnt/aleph_tab"
end

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'factory_girl'
require 'pry'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.filter_sensitive_data('http://aleph.library.edu') { Exlibris::Aleph::Config.base_url }
  c.filter_sensitive_data('http://primo.library.edu') { Exlibris::Primo::Config.base_url }
  c.filter_sensitive_data('http://solr.library.edu') { Sunspot.config.solr.url }
  c.filter_sensitive_data('AMAZON_API_KEY') { ENV['AMAZON_API_KEY'] }
  c.filter_sensitive_data('AMAZON_SECRET_KEY') { ENV['AMAZON_SECRET_KEY'] }
  c.filter_sensitive_data('AMAZON_ASSOCIATE_TAG') { ENV['AMAZON_ASSOCIATE_TAG'] }
  c.filter_sensitive_data('COVER_THING_DEVELOPER_KEY') { ENV['COVER_THING_DEVELOPER_KEY'] }
  c.filter_sensitive_data('GOOGLE_BOOK_SEARCH_API_KEY') { ENV['GOOGLE_BOOK_SEARCH_API_KEY'] }
  c.filter_sensitive_data('ISBN_DB_ACCESS_KEY') { ENV['ISBN_DB_ACCESS_KEY'] }
  c.filter_sensitive_data('NYU_SCOPUS_CITATIONS_JSON_API_KEY') { ENV['NYU_SCOPUS_CITATIONS_JSON_API_KEY'] }
  c.filter_sensitive_data('NS_BX_TOKEN') { ENV['NS_BX_TOKEN'] }
  c.filter_sensitive_data('BOR_ID') { ENV['BOR_ID'] }
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Include Factory Girl convenience methods
  config.include FactoryGirl::Syntax::Methods

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # In RSpec 3 onwards, the spec types are not inferred from the file location
  # by default so we tell RSpec to do just that
  # https://www.relishapp.com/rspec/rspec-rails/v/3-0/docs/upgrade#file-type-inference-disabled
  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before(:suite) do
    # Make sure all Factories are loaded and actually work
    FactoryGirl.reload
    FactoryGirl.lint

    # Startout by trucating all the tables
    DatabaseCleaner.clean_with :truncation
    # Then use transactions to roll back other changes
    # DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.strategy = :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end
