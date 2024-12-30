class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ] # Skip authentication for this action

  def index
    render json: { status: "wellll" }
  end
end
