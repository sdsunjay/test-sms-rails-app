Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  authenticated :user do
    resources :users, only: [:new, :create, :index, :show, :edit, :update, :destroy]
    match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
    post 'users/verify' => "user#verify"
    root to: 'users#index', as: :authenticated_root
  end
  root to: redirect('/users/sign_in')
end
