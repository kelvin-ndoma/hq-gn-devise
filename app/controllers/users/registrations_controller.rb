class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix

  respond_to :json

  # Ensure user is authenticated for updating and deleting their account
  before_action :authenticate_user!, only: [:update, :destroy]
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # Allow updates without requiring the current password for non-sensitive fields
  def update_resource(resource, params)
    if params[:password].blank? && params[:password_confirmation].blank?
      resource.update_without_password(params)
    else
      super
    end
  end

  # Custom JSON responses for different actions
  def respond_with(resource, _opts = {})
    case request.method
    when "POST"
      if resource.persisted?
        render json: {
          status: { code: 200, message: "Signed up successfully." },
          data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }, status: :ok
      else
        render json: {
          status: { code: 422, message: "User couldn't be created. #{resource.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    when "PUT", "PATCH"
      if resource.errors.empty?
        render json: {
          status: { code: 200, message: "Account updated successfully." },
          data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }, status: :ok
      else
        render json: {
          status: { code: 422, message: "Account couldn't be updated. #{resource.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    when "DELETE"
      render json: {
        status: { code: 200, message: "Account deleted successfully." }
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "Request couldn't be processed successfully." }
      }, status: :unprocessable_entity
    end
  end

  # Permit additional parameters for user registration and updates
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :bio, :city, :country, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :bio, :city, :country, :email, :password, :password_confirmation])
  end
end
