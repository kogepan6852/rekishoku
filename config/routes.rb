Rails.application.routes.draw do
# API route　
  # POSTS
  get 'api/posts', to: 'api_posts#index'
  get 'api/posts/:id', to: 'api_posts#show'
  get 'api/post_list', to: 'api_posts#list'
  post 'api/posts', to: 'api_posts#create'
  patch 'api/posts/:id', to: 'api_posts#update'
  delete 'api/posts/:id', to: 'api_posts#destroy'
  # POST DETAILS
  get 'api/post_details/:id', to: 'api_post_details#index'
  post 'api/post_details', to: 'api_post_details#create'
  patch 'api/post_details/:id', to: 'api_post_details#update'
  delete 'api/post_details/:id', to: 'api_post_details#destroy'
  # SHOPS
  get 'api/shops', to: 'api_shops#index'
  get 'api/shops/:id', to: 'api_shops#show'
  get 'api/shop_list', to: 'api_shops#list'
  get 'api/map', to: 'api_shops#map'
  # USERS
  get 'api/users', to: 'api_users#index'
  get 'api/users/:id', to: 'api_users#show'
  patch 'api/users/:id', to: 'api_users#update'
  # PEOPLE
  get 'api/people', to: 'api_people#index'
  get 'api/person_list', to: 'api_people#list'
  # CATEGORY
  get 'api/categories', to: 'api_categories#index'
  # PEOPLE POSTS
  post 'api/people_posts', to: 'api_people_posts#create'
  # POSTS SHOPS
  post 'api/posts_shops', to: 'api_posts_shops#create'
  # LOGIN
  get 'users/index'
  get 'users/show'

# ADMIN route
  resources :menu

  resources :people_shops

  resources :people_posts

  resources :posts_shops

  resources :people_periods

  resources :periods

  resources :categories_people

  resources :categories_shops

  resources :people

  resources :shops

  resources :post_details

  resources :categories

  # devise_for :users
  resources :posts

  resource :authentication_token, only: [:update, :destroy]
  devise_for :users, controllers: { sessions: "sessions", registrations: "registrations" }
  resources :users, :only => [:index, :show, :update]

  root to: 'menu#index'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'


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
