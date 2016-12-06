Rails.application.routes.draw do

  root to: 'app_route#show'
  # get 'app/post/*path', to: 'app_route#post'
  # get 'app/shop/*path', to: 'app_route#shop'
  get 'app/*path', to: 'app_route#show'
  get 'app', to: 'app_route#show'
  # 旧URL対応
  get 'post/*path', to: 'app_route#show'

  # ssl証明書発行用
  get ".well-known/acme-challenge/:id" => "app_route#letsencrypt"

  ### 
  # API route　
  ###
  # POSTS
  get 'api/posts', to: 'api_posts#index'
  get 'api/posts/:id', to: 'api_posts#show'
  get 'api/post_list', to: 'api_posts#list'
  get 'api/posts_related/:id', to: 'api_posts#relation'
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

  # FEATURES
  get 'api/features', to: 'api_features#index'
  get 'api/features/:id', to: 'api_features#show'

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
  # PERIODS
  get 'api/periods', to: 'api_periods#index'
  # LOGIN
  get 'users/index'
  get 'users/show'

  # ADMIN_SHOP
  post 'admin/shop/new', to: 'shops#create'
  put 'admin/shop/:id/edit', to: 'shops#update'

  # ADMIN_POST
  post 'admin/post/new', to: 'posts#create'
  put 'admin/post/:id/edit', to: 'posts#update'

  # ADMIN_POST_DETAIL
  put 'admin/post_detail/:id/edit', to: 'post_details#update'

  # ADMIN_FEATURE
  post 'admin/feature/new', to: 'features#create'
  put 'admin/feature/:id/edit', to: 'features#update'

  # ADMIN_ ExternalLink
  post 'admin/external_link/new', to: 'external_links#create'
  put 'admin/external_link/:id/edit', to: 'external_links#update'

  ### 
  # Site Map
  ###
  case Rails.env
    when 'production'
      get 'sitemap', to: redirect('https://s3-ap-northeast-1.amazonaws.com/rekishoku/sitemaps/sitemap.xml.gz')
    when 'staging'
      get 'sitemap', to: redirect('https://s3-ap-northeast-1.amazonaws.com/rekishoku-stg/sitemaps/sitemap.xml.gz')
  end

  resource :authentication_token, only: [:update, :destroy]
  devise_for :users, controllers: { sessions: "sessions", registrations: "registrations" }
  resources :users, :only => [:index, :show, :update]

  # root to: 'menu#index'
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
