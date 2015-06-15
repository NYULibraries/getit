class ApplicationController < ActionController::Base
  protect_from_forgery

  helper :institutions
  include InstitutionsHelper

  def url_for_request(request)
    url_for(controller: :resolve, action: :index, only_path: false,
      'umlaut.request_id' => request.id)
  end
  helper_method :url_for_request

  # Alias new_session_path as login_path for default devise config
  def new_session_path(scope)
    login_path
  end
end
