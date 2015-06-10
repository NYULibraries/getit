module GetIt
  class AlephPatron
    attr_reader :user, :id, :bor_status

    def initialize(user)
      unless user.is_a?(User)
        raise ArgumentError.new("Expecting #{user} to be a User")
      end
      unless user.aleph_id.blank?
        raise ArgumentError.new("Expecting #{user} to have an Aleph ID")
      end
      @user = user
      @id = user.aleph_id
      @bor_status = user.patron_status
    end

    def record(record_id)
      patron.record(record_id)
    end

    private
    def patron
      @patron ||= Exlibris::Aleph::Patron.new(id)
    end
  end
end
