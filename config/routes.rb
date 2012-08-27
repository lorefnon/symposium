Symposium::Application.routes.draw do
  resources :reputation_changes
  resources :activities
  resources :opinions

  resources :questions, :shallow => true do
    resources :answers
    resources :comments
  end

  devise_for :users

  resources :members, :shallow => true  do
    resources :questions do
    end
    resources :answers do
    end
    resources :comments do
    end
    resources :subscriptions do
    end
    resources :notifications do
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'questions#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  match '/community' => 'members#index'

  match '/:target_type/:target_id/opinion/:optype' => 'opinions#create',
  :via => :post

  match '/:target_type/:target_id/opinion/:optype' => 'opinions#update',
  :via => :put

  match '/questions/:id/accept/:answer_id' => 'questions#accept_ans',
  :via => :put

  match '/:opinion_tgt_type/:opinion_tgt_id/:op_classifier' => 'members#index',
  :optype => "upvote",
  :constraints => {:op_classifier => /(upvoters)|(downvoters)/}

  match '/:opinion_tgt_type/:opinion_tgt_id/downvoters' => 'members#index',
  :optype => "downvote",
  :via => :get

  match '/members/:member_id/subscribed/:target_type' => 'subscriptions#index',
  :constraints => {:target_type => /(questions)|(answers)|(users)/}
end
