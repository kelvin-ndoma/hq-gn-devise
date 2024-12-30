class Users::PasswordsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :create, :update ]

  def create
    user = User.find_by(email: params[:user][:email])
    if user
      user.send_reset_password_instructions
      render json: { status: { code: 200, message: "Reset password instructions sent." } }, status: :ok
    else
      render json: { status: { code: 404, message: "User not found with the provided email." } }, status: :not_found
    end
  end

  def update
    unless params[:user][:reset_password_token].present?
      render json: { status: { code: 400, message: "Reset password token is required." } }, status: :bad_request
      return
    end

    # Hash the provided token before querying the database
    hashed_token = Devise.token_generator.digest(User, :reset_password_token, params[:user][:reset_password_token])
    user = User.find_by(reset_password_token: hashed_token)

    Rails.logger.info("User: #{user.inspect}")
    Rails.logger.info("Provided token: #{params[:user][:reset_password_token]}")
    Rails.logger.info("Stored token: #{user&.reset_password_token}")

    if user
      if user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
        render json: { status: { code: 200, message: "Password successfully updated." } }, status: :ok
      else
        Rails.logger.error("Update failed: #{user.errors.full_messages.join(', ')}")
        render json: { status: { code: 422, message: "Password update failed." } }, status: :unprocessable_entity
      end
    else
      render json: { status: { code: 404, message: "Invalid or expired token." } }, status: :not_found
    end
  end
end
