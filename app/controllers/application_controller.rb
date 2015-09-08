class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :institutions
  include InstitutionsHelper

  prepend_before_filter :passive_login, unless: -> { Rails.env.test? || Rails.env.development? }
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

  # After signing out from the local application,
  # redirect to the logout path for the Login app
  def after_sign_out_path_for(resource_or_scope)
    if ENV['SSO_LOGOUT_PATH'].present?
      "#{ENV['LOGIN_URL']}#{ENV['SSO_LOGOUT_PATH']}"
    else
      super(resource_or_scope)
    end
  end

  private

  def passive_login_url
    "#{ENV['LOGIN_URL']}#{ENV['PASSIVE_LOGIN_PATH']}?client_id=#{ENV['APP_ID']}&origin=#{request_url_escaped}&return_uri=#{request_url_escaped}&login_path=#{login_path_escaped}"
  end

  def request_url_escaped
    CGI::escape(request.url)
  end

  def login_path_escaped
    CGI::escape("#{Rails.application.config.action_controller.relative_url_root}/login")
  end

end
