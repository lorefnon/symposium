Symposium::Application.routes.draw do
  resources :reputation_changes
  resources :activities
  resources :opinions
  resources :tags

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

  root :to => 'questions#index'

  match '/community' => 'members#index'
  match '/moderators/:id/dashboard' => 'moderators#dashboard'
  match '/admin/:id/dashboard' => 'admin#dashboard'

  match '/:target_type/:target_id/opinion/:optype' => 'opinions#create',
  :via => :post

  match '/:target_type/:target_id/opinion/:optype' => 'opinions#update',
  :via => :put

  match '/:target_type/:target_id/opinion/:optype' => 'opinions#delete',
  :via => :delete

  match '/questions/:id/accept/:answer_id' => 'questions#accept_ans',
  :via => :put

  match '/:opinion_tgt_type/:opinion_tgt_id/:op_classifier' => 'members#index',
  :optype => "upvote",
  :constraints => {:op_classifier => /(upvoters)|(downvoters)/}

  match '/:opinion_tgt_type/:opinion_tgt_id/downvoters' => 'members#index',
  :optype => "downvote",
  :via => :get

  match '/tags/:id/moderators/:moderator_id' => 'tags#add_moderator',
  :via => :post,
  :constraints => { :moderator_id => /\d*/ }

  match '/tags/:id/moderators/:moderator_id' => 'tags#remove_moderator',
  :via => :delete,
  :constraints => { :moderator_id => /\d*/ }

  match '/tags/:id/moderators' => 'tags#add_moderator',
  :via => :post,
  :constraints => { :moderator_name => /[a-zA-Z_-]*/ }

  match '/moderator/:moderator_id/tags' => 'tags#index',
  :via => :get

  match '/members/:member_id/subscribed/:target_type' => 'subscriptions#index',
  :constraints => {:target_type => /(questions)|(answers)|(users)/}
end
