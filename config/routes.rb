Parknet::Application.routes.draw do

  get "staff_registration/registration"

  get "browse_programs/show"

  get "customer_access/browse"

  get "customer_access/login"

	get "log_in" => "staff_sessions#new", :as => "log_in"
	get "staff_menu" => "staff_sessions#menu", :as => "staff_menu"
	#get "customer_root" => "customer_session/menu", :as => "customer_menu"
	root :to => "home#index"
	get "static_pages/home"
	get "static_pages/help"
	get "facilities/list"
	get "funds/list"
	get "staff_users/list"
	get "gl_accounts/list"
	get "season_titles/list"
	get "seasons/list"
	get "brochure_sections/list"
	get "brochure_sections/program_list"
	get "brochure_subsections/list"
	get "programs/list"
	get "programs/browse"
	get "class_sessions/list"
	get "programs/edit"
	get "accounts/list"
	get "accounts/edit"
	post "maintain_program" => "programs#edit", :as => "maintain_program"
	get "class_sessions/list_per_program"
	get "staff_registration/lookup_account"
	match 'staff', :to => 'staff_access#menu'
	get "class_sessions/edit"
	get "customers/add_member"
	get "customers/add_head_of_household"
	#get "facilities/new"
	resources :facilities
	resources :funds
	resources :gl_accounts
	resources :staff_users
	resources :season_titles
	resources :seasons
	resources :brochure_sections
	resources :brochure_subsections
	resources :programs
	resources :class_sessions
	resources :class_session_fees
	resources :staff_sessions
	resources :accounts
	resources :customers
	resources :customer_access
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
   #  resources :facilities

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
  match ':controller(/:action(/:id))(.:format)'
end
