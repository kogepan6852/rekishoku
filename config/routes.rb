Rails.application.routes.draw do
  resources :people_shops

  resources :menu

# API route　
  get 'api/people'
  get 'api/people/:id' , to: 'api#people'
  get 'api/shops'
  get 'api/shops/:id' , to: 'api#shops'
  get 'api/periods'
  get 'api/periods/:id' , to: 'api#periods'
  get 'api/people_posts'
  get 'api/people_posts/:id' , to: 'api#people_posts'
  get 'api/people_shops'
  get 'api/people_shops/:id' , to: 'people_shops#shops'
  get 'api/post_show'
  get 'api/post_show/:id' , to: 'post_show#shops'
  get 'api/posts_shops'
  get 'api/posts_shops/:id' , to: 'api#posts_shops'



  get 'users/index'
  get 'users/show'

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
  devise_for :users, controllers: { sessions: "sessions" }
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
