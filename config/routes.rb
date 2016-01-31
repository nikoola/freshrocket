Rails.application.routes.draw do

  # resources :users,      only: [:index, :show, :create, :update, :destroy]
  # resources :products,   only: [:index, :show, :create, :update, :destroy]

  # resources :orders,     only: [:index, :show, :create, :update, :destroy] #fix line_items from orders too


  # having resources :users do only means we are getting user id in nested routes.

  # no authentication needed.
  resources :products,   only: [:index, :show]


  mount_devise_token_auth_for 'User', at: 'auth' #this is for compatibility with ng
  resource :user, module: 'client', path: :client, as: :client, only: [:show] do
    resources :orders,    only: [:index, :show, :create, :update, :destroy]
  end


  namespace :admin do #admins see in admin panel
  #under /admin we will only have the urls that require admin account.
    resources :products,    only: [:create, :update, :destroy]
    resources :orders,      only: [:index, :show, :create, :update, :destroy]
    resources :users,       only: [:index, :show, :create, :update, :destroy]
  end


  # guest -> client -> admin. admin can use whatever urls.



# models/orders/line_item.rb
# models/order.rb



# I don't need a line_item controller, I'll interact with line_items through orders.




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
