class EZBorrowAuthorizer
  AUTHORIZED_BOR_STATUSES =
    %w{20 21 22 23 50 51 52 53 54 55 56 57 58 60 61 62 63 65 66 80 81 82}

  attr_reader :user

  def initialize(user)
    unless user.is_a?(User)
      raise ArgumentError.new("Expecting #{user} to be a User")
    end
    @user = user
  end

  def authorized?
    AUTHORIZED_BOR_STATUSES.include?(aleph_patron.bor_status)
  end

  private
  def aleph_patron
    @aleph_patron ||= GetIt::AlephPatron.new(user)
  end
end
