class UserSession < Authlogic::Session::Base
  pds_url "https://logindev.library.nyu.edu"
  redirect_logout_url "http://bobcatdev.library.nyu.edu"
  aleph_url "http://alephstage.library.nyu.edu"
  calling_system "umlaut"
  institution_param_key "umlaut.institution"

  # (Re-)Set verification and Aleph permissions to user attributes
  def additional_attributes
    h = {}
    return h unless pds_user
    h[:verification] = pds_user.verification
    h[:aleph_permissions] = {}
    h[:aleph_permissions][self.class.aleph_default_sublibrary] = aleph_bor_auth_permissions()
    return h
  end
end