class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :institutions
  include InstitutionsHelper

  prepend_before_filter :passive_login
  def passive_login
    if !cookies[:_check_passive_login]
      cookies[:_check_passive_login] = true
      redirect_to passive_login_url
    end
  end

  def url_for_request(request)
    url_for(controller: :resolve, action: :index, only_path: false,
      'umlaut.request_id' => request.id)
  end
  helper_method :url_for_request

  # Alias new_session_path as login_path for default devise config
  def new_session_path(scope)
    login_path
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  # After signing out from the local application,
  # redirect to the logout path for the Login app
  def after_sign_out_path_for(resource_or_scope)
    if logout_path.present?
      logout_path
    else
      super(resource_or_scope)
    end
  end

  private

  def logout_path
    if ENV['LOGIN_URL'].present? && ENV['SSO_LOGOUT_PATH'].present?
      "#{ENV['LOGIN_URL']}#{ENV['SSO_LOGOUT_PATH']}"
    end
  end

  def passive_login_url
    "#{ENV['LOGIN_URL']}#{ENV['PASSIVE_LOGIN_PATH']}"
  end

end
