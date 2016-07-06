class BorrowDirectController < UmlautBorrowDirect::ControllerImplementation
  def patron_barcode
    if current_user.present? && current_user.barcode.present?
      current_user.barcode      
    end
  end
end
