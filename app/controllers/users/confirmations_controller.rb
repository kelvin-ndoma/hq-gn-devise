# app/controllers/users/confirmations_controller.rb
class Users::ConfirmationsController < Devise::ConfirmationsController
    respond_to :json
  
    # GET /users/confirmation?confirmation_token=TOKEN
    def show
      @user = User.find_by(confirmation_token: params[:confirmation_token])
  
      if @user && @user.confirmation_token == params[:confirmation_token]
        render json: { status: { message: "Token is valid. Ready for confirmation." } }, status: :ok
      else
        render json: { status: { message: "Invalid or expired confirmation token." } }, status: :unprocessable_entity
      end
    end
  
    # POST /users/confirmation
    def create
      @user = User.find_by(confirmation_token: params[:confirmation_token])
  
      if @user && @user.confirmation_token == params[:confirmation_token]
        # Confirm the user by updating the confirmed_at field
        @user.update(confirmed_at: Time.current, confirmation_token: nil)
  
        # Send success message
        render json: { status: { message: "Your account has been confirmed!" } }, status: :ok
      else
        # Send error message if token is invalid or expired
        render json: { status: { message: "Invalid confirmation token." } }, status: :unprocessable_entity
      end
    end
  end
  