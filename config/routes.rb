Rails.application.routes.draw do
  # Route for requesting password reset (sends email with reset link)
  post "users/passwords/reset", to: "users/passwords#create"

  # Route for updating the password (protected action)
  patch "users/passwords/update", to: "users/passwords#update"

  # Route for fetching the current user's data
  get "/current_user", to: "current_user#index"

  # Devise routes with custom path names for login, logout, and signup
  devise_for :users, path: "", path_names: {
    sign_in: "login",    # Custom login path
    sign_out: "logout",  # Custom logout path
    registration: "signup" # Custom signup path
  },
  controllers: {
    sessions: "users/sessions",  # Custom sessions controller
    registrations: "users/registrations",  # Custom registrations controller
    passwords: "users/passwords",  # Custom passwords controller
    confirmations: "users/confirmations"  # Custom confirmations controller
  }

  # Custom routes for updating user details (for `PUT` and `PATCH`)
  devise_scope :user do
    put "users", to: "users/registrations#update"  # Update user details
    patch "users", to: "users/registrations#update"  # Same as PUT
    delete "users", to: "users/registrations#destroy"  # Delete user account

    # Custom routes for account confirmation
    # GET route to validate token (this is a simple token validation check)
    get "users/confirmation", to: "users/confirmations#show"  # GET route for confirmation token validation

    # POST route to handle confirmation action (this confirms the account)
    post "users/confirmation", to: "users/confirmations#create"  # POST route to actually confirm the account
  end

  # If in development environment, mount LetterOpenerWeb for email previews
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Admin routes
  namespace :admin do
    resources :users, only: [ :index, :create, :destroy, :update ]  # Admin can list, create, and delete users
  end

  # Health check route
  get "up", to: "rails/health#show", as: :rails_health_check

  # Root route
  root "home#index"
end
