class UsersController < ApplicationController

  def index
    @users = User.all.order(:username)
  end

  def show
    @user = User.find(params[:id])
  end

end