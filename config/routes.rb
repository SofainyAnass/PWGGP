Rails.application.routes.draw do

  resources :users do
    member do
      get :following, :followers, :feed, :settings, :membre_de
    end
  end
  
  resources :projects do
    member do
      get :members
    end
  end
   
  resources :datafiles, only: [:new, :create, :index]
  resources :relationships
  resources :sessions, :only => [:new, :create, :destroy]
  resources :contacts, :only => [:new, :create, :destroy, :update, :edit]
  resources :microposts, :only => [:create, :destroy]
    
  get '/accueil',:to => 'pages#acceuil' 
  root :to => 'pages#acceuil'  
  get '/administration', :to => 'pages#administration'
  get '/signup',  :to => 'pages#inscription'
  get '/signin',  :to => 'sessions#create'
  delete '/signout', :to => 'sessions#destroy'
  post "/users", :to => 'contacts#edit'
  
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
