require 'borrow_direct'
BorrowDirect::Defaults.api_base = ENV['EZBORROW_API_BASE']
BorrowDirect::Defaults.partnership_id = ENV['EZBORROW_PARTNERSHIP_ID']
BorrowDirect::Defaults.timeout = 60
