class User < ActiveRecord::Base
  require 'exlibris-aleph'

  attr_accessible :crypted_password, :current_login_at, :current_login_ip, :email, :firstname,
    :last_login_at, :last_login_ip, :last_request_at, :lastname, :login_count, :mobile_phone,
      :password_salt, :persistence_token, :refreshed_at, :session_id, :username
  serialize :user_attributes# , :aleph_permissions

  acts_as_authentic do |c|
    c.validations_scope = :username
    c.validate_password_field = false
    c.require_password_confirmation = false
    c.disable_perishable_token_maintenance = true
  end

  # Get the Aleph permissions for the given sub library.
  # e.g aleph_permissions_by_sub_library_code(adm_library_code, sub_library_code)
  def aleph_permissions_by_sub_library_code(*args)
    sub_library_code = args[1]
    # Get the Aleph permissions for the given sub library
    return aleph_permissions[sub_library_code] unless aleph_permissions[sub_library_code].nil?
    # We didn't get the permissions previously, so go get them now.
    # Add the necessary arguments
    args << user_attributes[:nyuidn]
    args << user_attributes[:verification]
    # Call Aleph Bor Auth X-Service to get permissions.
    aleph_permissions[sub_library_code] = bor_auth_permissions(*args)
    save_without_session_maintenance
    aleph_permissions[sub_library_code]
  end

  # Get the Aleph permissions from user attributes
  def aleph_permissions
    user_attributes[:aleph_permissions] = {} if user_attributes[:aleph_permissions].nil?
    @aleph_permissions ||= user_attributes[:aleph_permissions]
  end
  private :aleph_permissions

  # Get the hold request permission from the
  # Aleph BorAuth X-Service
  def bor_auth_permissions(*args)
    adm_library_code = args[0]
    sub_library_code = args[1]
    # Short circuit if we don't have enough data to make the call
    return {} if sub_library_code.nil? or adm_library_code.nil?
    bor_id = args[2]
    verification = args[3]
    aleph_url = UserSession.aleph_url
    bor_auth = 
      Exlibris::Aleph::Xservice::BorAuth.new(aleph_url, adm_library_code, sub_library_code, "N", bor_id, verification)
    # Log error and return nil if we have an error.
    if bor_auth.nil? or bor_auth.error
      logger.error "Error in #{self.class}. "+
        "No permissions returned from Aleph bor-auth for user with bor_id #{bor_id} and verification #{verification}.\n"+
          "Error: #{(bor_auth.nil?) ? "bor_auth is nil." : bor_auth.error.inspect}"
      return {}
    end
    return bor_auth.permissions
  end
  private :bor_auth_permissions
end
