class ILLAuthorizer < PatronStatusAuthorizer
  def initialize(user)
    super(user)
    @authorized_bor_statuses = Figs.env.ill_patron_statuses.map {|status| status["code"]} || {}
  end
end
