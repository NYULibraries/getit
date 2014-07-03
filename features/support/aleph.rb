# Use the included test mnt for cucumber.
Exlibris::Aleph.configure do |config|
  config.table_path = "#{File.dirname(__FILE__)}/../test/mnt/aleph_tab"
end
