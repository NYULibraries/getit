module GetIt
  class AlephPatron
    attr_reader :user, :id, :bor_status

    def initialize(user)
      unless user.is_a?(User)
        raise ArgumentError.new("Expecting #{user} to be a User")
      end
      unless user.user_attributes.is_a?(Hash)
        raise ArgumentError.new("Expecting #{user.user_attributes} to be a Hash")
      end
      @user = user
      @id = user.user_attributes[:nyuidn]
      @bor_status = user.user_attributes[:bor_status]
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
