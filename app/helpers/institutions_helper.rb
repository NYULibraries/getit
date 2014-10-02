module InstitutionsHelper
  # Determine current primary institution based on:
  #   0. institutions are not being used (returns nil)
  #   1. institution query string parameter in URL
  #   2. institution associated with the client IP
  #   3. primary institution for the current user
  #   4. first default institution
  def current_institution
    @current_institution ||= case
      when (institution_param.present? && institutions[institution_param])
        institutions[institution_param]
      when institution_from_ip.present?
        institution_from_ip
      when (@current_user && current_user.institution)
        current_user.institution
      else
        Institutions.defaults.first
      end
  end
  alias current_primary_institution current_institution
  alias current_institute current_institution

  # Override Rails #url_for to add institution 
  def url_for(options={})
    if institution_param.present? and options.is_a? Hash
      options[:institute] ||= institution_param
    end
    super options
  end

  # Grab the first institution that matches the client IP
  def institution_from_ip
    unless request.nil?
      @institution_from_ip ||= Institutions.with_ip(request.remote_ip).first
    end
  end
  private :institution_from_ip

  # All institutions
  def institutions
    @institutions ||= Institutions.institutions
  end
  private :institutions

  # The institution param as a Symbol
  def institution_param
    params["institute"].upcase.to_sym if params["institute"].present?
  end
  private :institution_param
end
