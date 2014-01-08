require 'exlibris-aleph'
class UserSession < Authlogic::Session::Base
  pds_url Settings.pds.login_url
  redirect_logout_url Settings.pds.logout_url
  aleph_url Exlibris::Aleph::Config.base_url
  calling_system "getit"
  institution_param_key "umlaut.institution"

  # (Re-)Set verification and Aleph permissions to user attributes
  def additional_attributes
    # Don't do anything unless the record is expired or there are no aleph permissions.
    return super unless (attempted_record.expired? or 
      attempted_record.user_attributes[:aleph_permissions].nil?)
    # Reset the aleph permissions
    permission_attributes = {}
    permission_attributes[:aleph_permissions] = {}
    # Get the bor_id and verification
    # Use the outdated values if we don't have a PDS user (used for testing).
    bor_id = pds_user ? pds_user.id : attempted_record.user_attributes[:nyuidn]
    verification = pds_user ? pds_user.verification : attempted_record.user_attributes[:verification]
    # Don't do anything unless we get a verification
    if (bor_id and verification)
      permission_attributes[:verification] = verification
      permission_attributes[:aleph_permissions][self.class.aleph_default_sublibrary] = 
        aleph_bor_auth_permissions(bor_id, verification)
    end
    return permission_attributes
  rescue
    return {}
  end
end
