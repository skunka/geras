Geras::Application.routes.draw do

  devise_for :users

  resources :users do as_routes end
  resources :roles do as_routes end
  resources :companies do as_routes end
  resources :users do 
	as_routes
  end
  resources :events do as_routes end
  resources :event_series do as_routes end
    
  get "pages/index"
  get "pages/about"
  get "pages/contact"
 
  get "monitors/application"
  get "monitors/database"
  get "monitors/web"

  match '/monitors',    :to => 'monitors#application'
  match '/database',    :to => 'monitors#database'
  match '/web',    :to => 'monitors#web'

  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  match '/calendar(/:year(/:month(/:day)))' => 'calendar#day', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/,:day => /\d{1,2}/}
  match '/calendar/acounting', :to => 'calendar#acounting'
  match '/calendar', :to => 'calendar#index'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

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
  root :to => "pages#index"

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
 match ':controller(/:action(/:id(.:format)))'
end
