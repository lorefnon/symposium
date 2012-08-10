class MembersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
  end

  def destroy
    redirect_to "/"
  end
end
