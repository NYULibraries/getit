class ILLAuthorizer < PatronStatusAuthorizer
  def initialize(user)
    super(user)
    @authorized_bor_statuses = patron_statuses
  end

  private
  # Get list of patron statuses from environment
  def patron_statuses
    # First check figs for hash version of patron statuses
    if (Figs.env.ill_patron_statuses.present?)
      Figs.env.ill_patron_statuses.map {|status| status["code"]}
    # Then check the local environment
    elsif ENV["ILL_PATRON_STATUSES"].present?
      ENV["ILL_PATRON_STATUSES"].split(",")
    else
      []
    end
  end
end
