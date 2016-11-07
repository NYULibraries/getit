require 'borrow_direct'
BorrowDirect::Defaults.api_base = ENV['EZBORROW_API_BASE']
BorrowDirect::Defaults.partnership_id = ENV['EZBORROW_PARTNERSHIP_ID']
BorrowDirect::Defaults.timeout = 60
# Override default production api base because engine config makes the above
# not work in a production environment
class BorrowDirect::Defaults
  PRODUCTION_API_BASE = ENV['EZBORROW_API_BASE']
end
