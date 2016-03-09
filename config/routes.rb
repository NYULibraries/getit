Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  Umlaut::Routes.new(self).draw

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy', as: :logout
    get 'login' => redirect{ |params, request| "#{Rails.application.config.relative_url_root}/users/auth/nyulibraries?#{request.query_string}" }, as: :login
  end

  # GET a new holding request form
  get 'holding_requests/new/:service_response_id' => 'holding_requests#new',
    as: :new_holding_request
  # POST to create a new holding request
  post 'holding_requests/:service_response_id' => 'holding_requests#create',
    as: :holding_requests
  # GET to create a new holding request
  get 'holding_requests/:service_response_id/:type(/:pickup_location)' =>
    'holding_requests#create', as: :create_holding_request
  # GET a holding request (confirmation of creation)
  get 'holding_requests/:service_response_id' => 'holding_requests#show',
    as: :holding_request

  get '*path' => 'application#routing_error'
end
