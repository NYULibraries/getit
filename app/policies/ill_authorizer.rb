class ILLAuthorizer < PatronStatusAuthorizer
  def initialize(user)
    super(user)
    @authorized_bor_statuses = patron_statuses
  end

  private
  def patron_statuses
    @patron_statuses ||= ["30", "31", "32", "34", "35", "37", "50", "51", "52", "53", "54", "55", "56", "57", "58", "60", "61", "62", "63", "65", "66", "80", "81", "82", "89"]
    # These are Shanghai patron statuses, which technically have ILL access
    # but also have "Recall" options through GetIt so we pretend they don't have
    # ILL access for GetIt's sake
    # "20", "21", "22", "23"
  end
end
