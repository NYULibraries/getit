class BorrowDirectController < UmlautBorrowDirect::ControllerImplementation
  def patron_barcode
    return ENV['EZBORROW_NYU_PATRON_BARCODE']
  end
end
