require 'borrow_direct'
BorrowDirect::Defaults.api_base = ENV['EZBORROW_NYU_API_BASE']
BorrowDirect::Defaults.api_key = ENV['EZBORROW_NYU_API_KEY']
BorrowDirect::Defaults.partnership_id = ENV['EZBORROW_PARTNERSHIP_ID']
BorrowDirect::Defaults.library_symbol = ENV['EZBORROW_NYU_LIBRARY_SYMBOL']
BorrowDirect::Defaults.find_item_patron_barcode = ENV['EZBORROW_NYU_PATRON_BARCODE']
BorrowDirect::Defaults.timeout = 10
