Rails.application.routes.draw do
  get "home/index"
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
 
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
