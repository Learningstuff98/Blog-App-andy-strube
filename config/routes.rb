Rails.application.routes.draw do
  devise_for :users
  resources :users, only: :show
  namespace :moderator do
    resources :subblogs, only: [:new, :create, :show] do
      resources :blogs, only: [:show, :destroy]
    end
  end
  resources :subblogs, only: [:index, :show] do
    resources :blogs, only: [:new, :create, :show, :edit, :update, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'subblogs#index'
end
