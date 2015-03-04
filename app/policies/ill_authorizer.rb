class ILLAuthorizer < PatronStatusAuthorizer
  def initialize(user)
    super(user)
    @authorized_bor_statuses = patron_statuses
  end

  private
  # Get list of patron statuses from environment
  #
  # The figs version of these environment variables will be an evaluated Hash or Array
  # If it's a Hash from configula the expected form is:
  # => {
  #     ILL_PATRON_STATUSES:
  #       - name: "Master's Student"
  #         code: "51"
  #    }
  # If it's an Array sent in from teh environment, just make sure to map it to string:
  # =>  ILL_PATRON_STATUSES=[01,02,03] => ["01","02","03"]
  def patron_statuses
    if Figs.env.ill_patron_statuses.try(:first).is_a? Hash
      Figs.env.ill_patron_statuses.map {|status| status["code"]}
    else
      Figs.env.ill_patron_statuses.try(:map) {|status| status.to_s} || []
    end
  end
end
