class ApplicationController < ActionController::Base
  protect_from_forgery

  # helper :institutions
  include Nyulibraries::Assets::InstitutionsHelper

  def url_for_request(request)
    url_for(controller: :resolve, action: :index, only_path: false,
      'umlaut.request_id' => request.id)
  end
  helper_method :url_for_request
end
