Rails.application.routes.draw do


	# no authentication needed.
	resources :categories, only: [:index]
	resources :products,   only: [:index, :show]
	resources :cities,     only: [:index, :show]

	resources :orders, only: [] do
		resources :positions,  only: [:index]
	end

	scope :forms do
		controller :forms do
			post :contact
		end
	end

	scope :users do
		controller :users do
			post :send_sms_with_recovery_password
		end
	end




	mount_devise_token_auth_for 'User', at: 'auth' #this is for compatibility with ng
	resource :user, module: 'client', path: :client, as: :client, only: [:show] do
		member {
			post :send_verification_sms
			put  :verify
		}

		resources :orders,    only: [:index, :show, :create, :update, :destroy] do
			member {
				put :update_status
			}
			collection{
				post :precalculate_price
			}
		end


		resources :payments,  only: [:new] do
			member {
				post :citrus
			}
		end

		resources :addresses, only: [:index, :create, :update, :destroy]


	end


	namespace :admin do #admins see in admin panel
	#under /admin we will only have the urls that require admin account.
		resources :categories,    only: [:create, :update, :destroy] do #no need for show
			member {
				put :update_image
			}
		end 
		resources :products,      only: [:create, :update, :destroy]
		resources :orders,        only: [:index, :show, :create, :update] do
			member {
				put :update_status     # status: ''
			}
		end
		resources :users,         only: [:index, :show, :create, :update] do
			member {
				put :update_abilities  # update abilities for a user
			}
		end
		resources :delivery_boys, only: [:index]
		resource  :settings,      only: [:show, :update]
		resources :coupons,       only: [:index, :create, :update, :destroy]
		resources :cities,        only: [:create, :update, :destroy]
		resources :addresses,     only: [:index, :create, :update, :destroy]

		get '/stats' => 'stats#stats'
	end



	namespace :deliver do
		resource  :delivery_boy,  only: [:update]
		resources :orders,        only: [:index, :update] do
			member {
				put :update_status
				resources :positions, only: [:create]
			}
		end
		
	end



	require 'sidekiq/web'
	Sidekiq::Web.use Rack::Auth::Basic do |username, password|
	  username == ENV["sidekiq.username"] && password == ENV["sidekiq.password"]
	end if Rails.env.production?

	mount Sidekiq::Web => '/sidekiq'






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
