class PatronStatusAuthorizer

  attr_reader :user, :authorized_bor_statuses

  def initialize(user)
    unless user.is_a?(User)
      raise ArgumentError.new("Expecting #{user} to be a User")
    end
    @user = user
  end

  def authorized?
    if authorized_bor_statuses.nil?
      raise ArgumentError.new("Expecting subclass to initialize authorized borrower status list")
    end
    authorized_bor_statuses.include?(aleph_patron.bor_status)
  end

  private
  def aleph_patron
    @aleph_patron ||= GetIt::AlephPatron.new(user)
  end

end
