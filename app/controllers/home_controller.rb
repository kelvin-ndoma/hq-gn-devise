class HomeController < ApplicationController
  def index
    render json: {status: "wellll"}
  end
end
