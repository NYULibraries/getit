class UserSession < Authlogic::Session::Base
  pds_url (ENV['PDS_URL'] || 'https://login.library.nyu.edu')
  redirect_logout_url 'http://bobcat.library.nyu.edu'
  calling_system 'getit'
  institution_param_key 'umlaut.institution'
end
