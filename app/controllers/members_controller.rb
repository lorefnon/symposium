class MembersController < ApplicationController
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

  def show
    return unless protect_against_missing do
      @user = User.find params[:id]
    end
    respond_to do |format|
      format.html
      format.json {
        render :json => @user
      }
    end
  end

  def destroy
    return unless protect_against_missing do
      @user = User.find params[:id]
    end
    authorize_action_for @user
    cur_id = current_user.id
    des_id = @user.id

    if @user.destroy
      respond_to do |format|
        format.html {
          flash[:success] = "Member successfully deleted"
          if cur_id == des_id
            redirect_to "/user/sign_out"
          else
            redirect_to "/"
          end
        }
        format.json {
          render :json => {:success => "Member deleted"}
        }
      end
    else
      err_str = "Member could not be deleted"
      respond_to do |format|
        format.html {
          flash[:error] = err_str
          redirect_to "/"
          return
        }
        format.json {
          render :status => 500, :json => {:error => err_str}
        }
      end
    end
  end

  def edit
    return unless protect_against_missing do
      @user = User.find params[:id]
    end
    authorize_action_for @user
  end

  def update
    return unless protect_against_missing do
      print params.to_json
      @user = User.find params[:id]
    end

    authorize_action_for @user

    if @user.update_profile params[:user]
      flash[:success] = "Profile updated successful"
      respond_to do |format|
        format.html {
          redirect_to :action => :show
        }
        format.json {
          render :json => @user
        }
      end
    else
      err_str = "Profile could not be updated"
      flash[:error] = err_str
      respond_to do |format|
        format.html {
          redirect_to :action => :edit
        }
        format.json {
          render :status => 500, :json => {
            :error => err_str,
            :details => @user.errors
          }
        }
      end
    end
  end
end
