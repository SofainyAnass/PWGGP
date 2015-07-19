Rails.application.routes.draw do

  resources :users do
    get :get_events, on: :collection
    member do
      get :following, :followers, :feed, :settings, :membre_de, :fichiers_utilisateur
    end
  end
  
  resources :projects do       
    member do
      get :members
      get :remove_member     
      post :add_member
    end
  end
  
  
  
  #a supprimer et laisser seulement celui des versions
  resources :datafiles do
    member do
      get :download, :delete_file, :versions_fichier
    end
  end
  
  resources :versions do
    member do
      get :download
    end
  end
  
  resources :contacts do
    get :autocomplete_contact_nom, :on => :collection
  end
  
  resources :messages
  resources :relationships
  resources :sessions, :only => [:new, :create, :destroy] 
  resources :microposts, :only => [:create, :destroy]
    
  get '/accueil',:to => 'pages#acceuil' 
  root :to => 'pages#acceuil'  
  get '/administration', :to => 'pages#administration'
  get '/signup',  :to => 'pages#inscription'
  get '/signin',  :to => 'sessions#create'
  get '/projet', :to => 'pages#projet'
  get '/calendrier', :to => 'pages#calendrier'
  get '/ged', :to => 'pages#ged'
  delete '/signout', :to => 'sessions#destroy'
  post "/users", :to => 'contacts#edit'
  post "/projects/add_member", :to => 'projects#add_member'
  post "/projects/remove_member", :to => 'projects#remove_member'
  
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
