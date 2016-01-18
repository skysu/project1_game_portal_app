class UsersController < ApplicationController

  def index
    @users = User.of_role(['player', 'ai']).order(:username)
  end

  def show
    @user = User.find(params[:id])
  end

end