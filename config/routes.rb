Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :edit, :update, :destroy]
  resources :teams do
    resources :memberships, only: [:create, :destroy]
    get :autocomplete_users, on: :member
  end
  resources :services do
    resources :plans, controller: :service_plans
    resources :grants, controller: :service_grants, only: [:create, :destroy]
  end
  root 'services#index'
end
