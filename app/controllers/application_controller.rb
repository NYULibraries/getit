class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :institutions
  include InstitutionsHelper

  def routing_error
    if request.format.html?
      render 'errors/404', layout: 'error', status: 404
    elsif request.format.xml?
      render xml: {file: request.path_info, error: "does not exist"}, status: 404
    else
      render json: {file: request.path_info, error: "does not exist"}.to_json, status: 404
    end
    return
  end

  # Override rails url_for to add institution parameter
  # This has to be defined in the controller so that controller logic
  # in Umlaut sees the override functionality.
  #
  # Ex.
  # => url_for({controller: 'resolve'}) === 'http://test.host/resolve?umlaut.insitution=#{current_institution}'
  # => url_for(http://test.host/resolve?rft.object_id=1234) === 'http://test.host/resolve?rft.object_id=1234&umlaut.insitution=#{current_institution}'
  def url_for(options={})
    if institution_param.present?
      if options.is_a?(Hash)
        options[institution_param_name] ||= institution_param
      elsif options.is_a?(String)
        options = append_parameter_to_url(options, institution_param_name, institution_param)
      end
    end
    super(options)
  end

  def append_parameter_to_url(url, key, value)
    if url.include?('?')
      url += '&'
    else
      url += '?'
    end
    url += "#{key}=#{URI.encode(value.to_s)}"
  end
  private :append_parameter_to_url

  def current_user_dev
    # Assuming you have a dev user on your local environment
    @current_user ||= User.where(institution_code: :NYU).first
  end
  alias_method :current_user, :current_user_dev if Rails.env.development?

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
    "#{ENV['LOGIN_URL']}#{ENV['PASSIVE_LOGIN_PATH']}?client_id=#{ENV['APP_ID']}&return_uri=#{request_url_escaped}"
  end

  def request_url_escaped
    CGI::escape(request.url)
  end

end
