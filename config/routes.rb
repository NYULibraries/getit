GetIt::Application.routes.draw do
  Umlaut::Routes.new(self).draw

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  match 'login', :to => 'user_sessions#new', :as => :login
  match 'logout', :to => 'user_sessions#destroy', :as => :logout
  match 'validate', :to => 'user_sessions#validate', :as => :validate
  resources :user_sessions

  # match 'requests/reset/:id', :to => 'requests#reset', :as => :reset_requests
  # match 'requests/send/:id/:pickup_location', :to => 
  # RequestsHelper.request_types.each do |type|
  #   match "requests/send_#{type}/:id/:pickup_location", :to => "requests#send_#{type}", :as => "send_#{type}_requests".to_sym
  #   match "requests/send_#{type}/:id", :to => "requests#send_#{type}", :as => "send_#{type}_requests".to_sym
  # end
  # match 'requests', :to => 'requests#create', :as => :new_requests, :via => :get
  # match 'requests/:id', :to => 'requests#show', :as => :request, :via => :get
  # GET a new request form
  match 'requests/new/:service_response_id', :to => 'requests#new', :as => :new_request, :via => :get
  # POST to create a new request
  match 'requests/:service_response_id', :to => 'requests#create', :as => :requests, :via => :post
  # GET to create a new request
  match 'requests/:service_response_id/:request_type(/:pickup_location)', :to => 'requests#create', :as => :create_request, :via => :get
  # GET a request (confirmation of creation)
  match 'requests/:service_response_id', :to => 'requests#show', :as => :request, :via => :get

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
