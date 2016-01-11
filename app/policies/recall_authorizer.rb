class RecallAuthorizer
  attr_accessor :user
  def initialize(user)
    @user = user
  end

  # User can recall a book only if ILL is not an option
  # and Ezborrow is not an option, except for institutions where
  # ezborrow users should still be able to recall
  def authorized?
    !ill_authorizer.authorized? && (default_recallable? || ns_recallable?)
  end

 private

  def default_recallable?
    !ezborrow_authorizer.authorized?
  end

  def ns_recallable?
    ezborrow_authorizer.ns_ezborrow?
  end

  def ill_authorizer
    @ill_authorizer ||= ILLAuthorizer.new(user)
  end

  def ezborrow_authorizer
    @ezborrow_authorizer ||= EZBorrowAuthorizer.new(user)
  end

end
