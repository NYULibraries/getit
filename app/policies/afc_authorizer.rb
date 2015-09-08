class AFCScheduleAuthorizer < PatronStatusAuthorizer
  def initialize(user)
    super(user)
    @authorized_bor_statuses = %w{03 05 10 12 20 30 32 50 52 53 54 61 62 70 80 89 90 55}
  end
end
