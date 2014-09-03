WhitePages::Application.routes.draw do
  get "graph/index"

  match 'graph/phone' => "graph#index", :as => :graph_phones, :via => :get
  match 'graph/phone' => "graph#index", :as => :graph_phones, :via => :post

  match 'graph/business' => "graph#find_business", :as => :graph_business, :via => :get
  match 'graph/business' => "graph#find_business", :as => :graph_business, :via => :post


  match 'graph/person' => "graph#person", :as => :graph_person, :via => :get
  match 'graph/person' => "graph#person", :as => :graph_person, :via => :post

  match 'graph/address' => "graph#address", :as => :graph_address, :via => :get
  match 'graph/address' => "graph#address", :as => :graph_address, :via => :post
  match 'graph/search' => "graph#search", :as => :search, :via => :post

  match 'graph/search_graph' => "graph#search_graph", :as => :search_graph, :via => :get




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
  # root :to => 'graph#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
