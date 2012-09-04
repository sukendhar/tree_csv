class UsersController < ApplicationController
	before_filter :authenticate_user!
  def index
  	@users = User.all
  end

  def show
  	@uses = User.find(params[:id])
  end
end
