Rails.application.routes.draw do
  devise_for :users
  resources :users, only: :show
  namespace :moderator do
    resources :subblogs, only: [:new, :create, :show] do
      resources :blogs, only: [:show, :destroy, :edit, :update, :new, :create] do
        resources :comments, only: [:destroy, :create, :edit, :update] do
          resources :responses, only: [:destroy, :new, :create, :edit, :update]
        end
      end
    end
    resources :locks, only: [:show, :update]
  end
  resources :subblogs, only: [:index, :show] do
    resources :blogs, only: [:new, :create, :show, :edit, :update, :destroy] do
      resources :photos, only: [:create]
      resources :comments, only: [:create, :destroy, :edit, :update, :show] do
        resources :responses, only: [:new, :create, :show, :destroy, :edit, :update]
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'subblogs#index'
end
