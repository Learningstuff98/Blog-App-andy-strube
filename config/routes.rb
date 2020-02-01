Rails.application.routes.draw do
  devise_for :users
  resources :users, only: :show
  resources :subblogs do
    resources :blogs, only: [:new, :create, :show]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'subblogs#index'
end
