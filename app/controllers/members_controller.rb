class MembersController < ApplicationController
  def model_class; User end

  def index
    @users = User.includes(:tag_priviledges => [:tag])
    if params.has_key? :user_name and not params[:user_name].empty?
      sql = "user_name LIKE ?"
      @users = @users.where(sql, ["%#{params[:user_name]}%"])
    end

    if params.has_key? :priv_tags and not params[:priv_tags].empty?
      @users = @users.where("tags.name = ?", params[:priv_tags].split(" "))
    end

    params[:page] = 1 unless params.has_key? :page

    @users = @users.paginate :page => params[:page]

    respond_to do |format|
      format.html
      format.json {
        render :json => @users.entries
      }
    end

  end

  def destroy
    authorize_action_for @inst
    cur_id = current_user.id
    des_id = @inst.id
    @success =  @inst.destroy
  end

  private

  def gen_deletion_success_response
    msg = "User account successfully removed"
    cur_id = current_user.id
    des_id = @inst.id

    format.html {
      flash[:success] = msg
      if cur_id == des_id
        redirect_to "/users/sign_out"
      else
        redirect_to "/"
      end
    }
    format.js {
      render :json => {:success => msg}
    }
  end
end
