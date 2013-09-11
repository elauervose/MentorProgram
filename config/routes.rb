Mentor::Application.routes.draw do
  
  resources :answers
  resources :mentor_asks, controller: :mentor_asks
  resources :pair_asks, controller: :pair_asks
  #resources :asks

  root to: 'static#index'
  get "about", to: 'static#about'
  get "table_test", to: 'static#table_test'
  get "mentors", to: 'mentor_asks#index', as: 'mentors_sign_up'
  get "mentees", to: 'mentor_asks#new'
  get "prep", to: 'static#prep'
  get "resources", to: 'static#resources'
  get "thank_you_mentor", to: 'static#thank_you_mentor'
  get "thank_you_mentee", to: 'static#thank_you_mentee'
  get "thank_you_pair_request", to: 'static#thank_you_pair_request'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
