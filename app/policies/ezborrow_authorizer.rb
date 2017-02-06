class EZBorrowAuthorizer < PatronStatusAuthorizer
  def initialize(user)
    super(user)
    @authorized_bor_statuses = nyu_ezborrow_statuses + ns_ezborrow_statuses
  end

  def ns_ezborrow?
    ns_ezborrow_statuses.include?(aleph_patron.bor_status)
  end

  def nyu_ezborrow?
    nyu_ezborrow_statuses.include?(aleph_patron.bor_status)
  end

 private

  def nyu_ezborrow_statuses
    @nyu_ezborrow_statuses ||= %w{50 51 52 53 54 55 56 57 58 60 61 62 63 65 66 80 81 82}
  end

  def ns_ezborrow_statuses
    @ns_ezborrow_statuses ||= %w{30 31 32 33 34 35 36 37 38 39 40 41}
  end
end
