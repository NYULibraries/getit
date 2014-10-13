module EZBorrowHelper
  def can_ezborrow?
    current_user.present? && ezborrow_authorizer.authorized?
  end

  def ezborrow_url(holding)
    @ezborrow_url =
      "#{HoldingRequestsController::EZBORROW_BASE_URL}/ezborrow?query=#{CGI::escape(holding.title)}"
  end

  private
  def ezborrow_authorizer
    @ezborrow_authorizer ||= EZBorrowAuthorizer.new(current_user)
  end
end
