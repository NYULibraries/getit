class AlephUser
  attr_reader :bor_id, :verification

  def initialize(user)
    unless user.is_a?(User)
      raise ArgumentError.new("Expecting #{user} to be a User")
    end
    unless user.user_attributes.is_a?(Hash)
      raise ArgumentError.new("Expecting #{user.user_attributes} to be a Hash")
    end
    @bor_id = user.user_attributes[:nyuidn]
    @verification = user.user_attributes[:verification]
    # Make sure the user object has aleph permissions
    @attribute_permissions = user.user_attributes[:aleph_permissions] ||= {}
  end

  def can_request?(holding)
    permissions(holding)[:hold_permission] == 'Y'
  end

  def can_request_available?(holding)
    can_request?(holding) && permissions(holding)[:hold_on_shelf] == 'Y'
  end

  private
  def permissions(holding)
    unless holding.is_a?(Holding)
      raise ArgumentError.new("Expecting #{holding} to be a Holding")
    end
    sub_library_code = holding.sub_library_code
    if @attribute_permissions[sub_library_code].nil?
      @attribute_permissions[sub_library_code] = bor_auth_permissions(holding)
    else
      @attribute_permissions[sub_library_code]
    end
  end

  def bor_auth_permissions(holding)
    adm = holding.adm_library_code
    sub_library = holding.sub_library_code
    bor_auth =
      Exlibris::Aleph::Xservice::BorAuth.new(url, adm, sub_library, 'N', bor_id, verification)
    log_errors!(bor_auth)
    errors?(bor_auth) ? {} : bor_auth.permissions
  end

  def errors?(bor_auth)
    (bor_auth.nil? or bor_auth.error)
  end

  def log_errors!(bor_auth)
    if errors?(bor_auth)
      Rails.logger.error "Error in #{self.class}. "+
        "No permissions returned from Aleph bor-auth for user with bor_id #{bor_id} and verification #{verification}.\n"+
        "Error: #{(bor_auth.nil?) ? "BorAuth is nil." : bor_auth.error.inspect}"
    end
  end

  def url
    @url ||= Exlibris::Aleph::Config.base_url
  end
end
