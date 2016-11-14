module InstitutionsHelper
  include ::NyulibrariesInstitutions::InstitutionHelper

  # Override default institution_param_name from nyulibraries-assets helper
  # default is 'institution'
  def institution_param_name
    'umlaut.institution'
  end

end
