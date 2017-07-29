Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  devise_for :users, :skip => [:sessions],
    :controllers => {
      registrations: "users/registrations",
      sessions: "users/sessions"
    }
    as :user do
      post '/register' => 'users/registrations#create', :as => :register
      post 'users/login' => 'users/sessions#create'
      delete 'users/:user_id/logout' => 'users/sessions#destroy'
      post '/users/:user_id/password' => 'users/sessions#update_password'
    end

  devise_scope :user do
    delete 'delete_account' => 'registrations#destroy', :as => :delete_account
  end

  root 'home#index'

  post '/reminder' => 'reminders#create'

  post '/reminder/edit' => 'reminders#edit'

  post '/receive_sms' => 'messages#receive_sms'

  post '/palm_sms' => 'messages#palm_sms'
  post '/palm_code' => 'messages#palm_code'
  post '/palm_honeypot' => 'messages#palm_honeypot'
  post '/palm_patsy' => 'messages#palm_patsy'
  post '/palm_patsy_pink' => 'messages#palm_patsy_pink'
  get '/palm_motolite' => 'messages#palm_motolite'
  post '/palm_inquiries' => 'messages#palm_inquiries'

  get '/get_s3_upload_key' => 'messages#get_s3_upload_key'

  post '/reminder/take' => 'reminders#take'

  get '/reminder/set' => 'reminders#set'

  get '/patient/list' => 'patients#list'

  get '/patient/:patient_id' => 'patients#get_patient'

  get '/patient/:patient_id/schedule/:schedule_id' => 'patients#get_schedule'

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
  get '*path' => 'home#index'
end
