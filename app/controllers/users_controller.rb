class UsersController < Devise::OmniauthCallbacksController
  before_filter :require_valid_omniauth, only: :nyulibraries

  def after_omniauth_failure_path_for(scope)
    root_path
  end

  def nyulibraries
    @user = User.where(username: omniauth.uid, provider: omniauth_provider).
      first_or_create(attributes_from_omniauth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "NYU Libraries") if is_navigational_format?
    else
      session["devise.nyulibraries_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end

  private
  def require_valid_omniauth
    head :bad_request unless valid_omniauth?
  end

  def valid_omniauth?
    omniauth.present? && omniauth.provider.to_s == 'nyulibraries'
  end

  def omniauth
    @omniauth ||= request.env["omniauth.auth"]
  end

  def omniauth_provider
    @omniauth_provider ||= omniauth.extra.provider
  end

  def attributes_from_omniauth
    {
      email: omniauth_email,
      firstname: omniauth_firstname,
      lastname: omniauth_lastname,
      institution_code: omniauth_institution_code,
      aleph_id: omniauth_aleph_id
    }
  end

  def omniauth_email
    @omniauth_email ||= omniauth.info.email
  end

  def omniauth_firstname
    @omniauth_firstname ||= omniauth.info.first_name
  end

  def omniauth_lastname
    @omniauth_lastname ||= omniauth.info.last_name
  end

  def omniauth_institution_code
    @omniauth_institution_code ||= omniauth.extra.institution_code
  end

  def omniauth_identities
    @omniauth_identities ||= omniauth.extra.identities
  end

  def omniauth_aleph_identity
    @omniauth_aleph_identity ||= omniauth_identities.find do |omniauth_identity|
      omniauth_identity.provider == 'aleph'
    end
  end

  def omniauth_aleph_id
    unless omniauth_aleph_identity.blank?
      @omniauth_aleph_id ||= omniauth_aleph_identity.uid
    end
  end
end
