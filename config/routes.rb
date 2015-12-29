Rails.application.routes.draw do
  resources :people_shops

  resources :menu

# API route　
  get 'api_people/people'
  get 'api_people/people/:id' , to: 'api_people#people'
  get 'api_shop/shops'
  get 'api_shop/shops/:id' , to: 'api_shop#shops'
  get 'api_period/periods'
  get 'api_period/periods/:id' , to: 'api_period#periods'
  get 'api_post/posts'
  get 'api_post/posts/:id' , to: 'api_post#posts'
  get 'api_post/categories'
  get 'api_post/categories/:id' , to: 'api_post#categories'
  get 'api_post/post_details'
  get 'api_post/post_details/:id' , to: 'api_post#post_details'


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
