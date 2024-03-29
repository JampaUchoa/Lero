Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :rooms, only: [:index, :create, :update]
  get '/room/join/:id/' => 'rooms#join'
  post '/room/leave/:id/' => 'rooms#leave'
  get '/room/share/:id/' => 'rooms#share'
  get '/room/edit/:id/' => 'rooms#edit'
  get '/join/:id' => 'rooms#directjoin'
  get '/embed/:id' => 'main#embed'

  get '/message/receive/:id' => 'chats#receive'
  post '/message/send' => 'chats#sendmsg'
  post '/room/ban' => 'rooms#ban', as: 'room_user_ban'

  patch '/user/set-name' => 'users#set_name', as: 'user_name_set'
  patch '/user/set-pass' => 'users#set_password', as: 'user_password_set'
  patch '/user/set-profile' => 'users#set_profile', as: 'user_profile_set'

  patch '/room/' => 'rooms#update'


  post '/user/hello' => 'users#hello'
  post '/user/goodbye' => 'users#goodbye'
  get '/user/:id' => 'users#show'
  delete '/user/wipe/:id' => 'users#wipe', as: 'wipe_user'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'

  resources :users
  # You can have the root of your site routed with "root"
  root 'main#chat'

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
