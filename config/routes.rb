Parknet::Application.routes.draw do

  post "headshot/capture" => 'headshot#capture', :as => :headshot_capture

  devise_for :users

	root :to => "staff_access#login"

	get "staff_registration/registration"
	get "browse_programs/show"
	get "customer_access/browse"
	match 'customer/login', :to => 'customer_access#login'
	match 'staff_menu', :to => 'staff_sessions#menu'
	#match ':controller(/:action(/:agency_id(/:id)))(.:format)'
	get "log_in" => "staff_sessions#new", :as => "log_in"
	get "staff_menu" => "staff_sessions#menu", :as => "staff_menu"
	#get "customer_menu" => "customer_access#menu", :as => "customer_menu"
	get "staff_access/select_location"
	get "customer_access/menu"
	get "customer_access/logout"
	get "online_registration/view_basket"
	get "online_registration/waiver"
	get "online_registration/checkout"
	get "online_registration/take_payment"
	get "online_registration/no_payment"
	get "static_pages/home"
	get "static_pages/help"
	get "facilities/list"
	get "facility_types/list"
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
	get "accounts/search"
	get "refunds/process_refunds"
	get "membership1_level_ones/list"
	post "maintain_program" => "programs#edit", :as => "maintain_program"
	get "class_sessions/list_per_program"
	post "new_class_session" => "class_session#new", :as => "new_class_session"
	get "staff_registration/lookup_account"
	get "payments/take_payment"
	match 'staff', :to => 'staff_access#menu'
	match 'customer', :to => 'customer_access#menu'
	get "class_sessions/edit"
	get "customers/add_member"
	get "customers/add_head_of_household"
	get "online_registration/show"
	get 'staff_membership_sales/update_level_two', :as => 'update_level_two'
	get 'staff_membership_sales/update_level_three', :as => 'update_level_three'
	get 'staff_membership_sales/update_term', :as => 'update_term'
	get 'staff_membership_sales/update_fees', :as => 'update_fees'
	get 'registrations/update_programs', :as => 'update_programs'
	get 'registrations/update_class_sessions', :as => 'update_class_sessions'
	get "accounting_transactions/select_gl_report_date"
	get "payments/select_daily_cash_balance_report_date"
	#root :to => "staff_membership_sales#memberships"
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
	resources :payments
	resources :charges
	resources :online_registration
	resources :refunds
	resources :facility_types
	resources :membership_level_ones
	resources :membership_level_twos
	resources :membership_level_threes
	resources :memberships
	resources :membership_terms
	resources :membership_scans
	
  
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
