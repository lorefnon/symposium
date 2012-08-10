class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
    authorize_action_for @user
  end

  def destroy
    @user = User.find params[:id]
    authorize_action_for @user
    redirect_to "/"
  end
end
