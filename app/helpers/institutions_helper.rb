module InstitutionsHelper
  include Nyulibraries::Assets::InstitutionsHelper

  # Override default institution_param from nyulibraries-assets helper
  def institution_param
    params['umlaut.institution'].upcase.to_sym if params['umlaut.institution'].present?
  end
  private :institution_param

end
