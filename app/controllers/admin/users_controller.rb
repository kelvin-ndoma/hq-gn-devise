class Admin::UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
  
    # Admin can see a list of all users
    def index
      @users = User.all
      render json: @users
    end
  
    # Admin can delete a user account
    def destroy
      @user = User.find(params[:id])
      if @user.destroy
        render json: { status: 200, message: "User account deleted successfully." }, status: :ok
      else
        render json: { status: 422, message: "User account couldn't be deleted." }, status: :unprocessable_entity
      end
    end
  
    # Admin can create a new user, but only an admin can assign the 'admin' role
    def create
      @user = User.new(user_params)
  
      # Only admins can assign the 'admin' role
      if params[:user][:admin] == "true" && !current_user.admin?
        render json: { status: 403, message: "Only admins can assign the admin role." }, status: :forbidden
        return
      end
  
      if @user.save
        render json: { status: 201, message: "User created successfully.", user: @user }, status: :created
      else
        render json: { status: 422, message: "User could not be created. #{@user.errors.full_messages.to_sentence}" }, status: :unprocessable_entity
      end
    end
  
    # Admin can update a user's 'admin' role
    def update
      @user = User.find(params[:id])
  
      # Only admin users can update the 'admin' role
      if params[:user][:admin].present? && !current_user.admin?
        render json: { status: 403, message: "Only admins can modify the admin role." }, status: :forbidden
        return
      end
  
      if @user.update(user_params)
        render json: { status: 200, message: "User updated successfully.", user: @user }, status: :ok
      else
        render json: { status: 422, message: "User could not be updated. #{@user.errors.full_messages.to_sentence}" }, status: :unprocessable_entity
      end
    end
  
    private
  
    # Ensure that the current user is an admin
    def check_admin
      unless current_user&.admin?
        render json: { status: 403, message: "Access forbidden: Admins only." }, status: :forbidden
      end
    end
  
    # Strong parameters to permit user attributes, excluding the 'admin' field
    def user_params
      # Only permit attributes that are safe for mass assignment
      params.require(:user).permit(:first_name, :last_name, :bio, :city, :country, :email, :password, :password_confirmation)
    end
  end
  