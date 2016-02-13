Rails.application.routes.draw do


	# having resources :users do only means we are getting user id in nested routes.

	# no authentication needed.
	resources :categories, only: [:index]
	resources :products,   only: [:index, :show]




	mount_devise_token_auth_for 'User', at: 'auth' #this is for compatibility with ng
	resource :user, module: 'client', path: :client, as: :client, only: [:show] do
		resources :orders,    only: [:index, :show, :create, :update] do #TODO can only destroy if order.condirmed? or order.unconfirmed?
			member {
				put :update_status
			}
		end
	end


	namespace :admin do #admins see in admin panel
	#under /admin we will only have the urls that require admin account.
		resources :categories,  only: [:create, :update, :destroy] #no need for show
		resources :products,    only: [:create, :update, :destroy]
		resources :orders,      only: [:index, :show] do
			member {
				put :update_status     # status: ''
				# get :may_update_status # status: ''
			}
		end
		resources :users,       only: [:index, :show, :update] do
			member {
				put :update_abilities #update abilities for a user
				get :list_abilities   #see user abilities
			}
		end
		resource :settings,      only: [:show, :update]
	end



	namespace :deliver do
		resource  :delivery_boy, only: [:update]
		resources :deliveries,   only: [:index]
		resources :orders,       only: [] do #TODO scope
			member {
				put :update_status
			}
		end
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
