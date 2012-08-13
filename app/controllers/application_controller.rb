class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html, :json

  def model_class; controller_name.classify.constantize end

  def retrieve_inst
    protect_against_missing do
      @inst = model_class.find params[:id]
    end
  end

  def protect_against_missing id=:id
    unless params.has_key? id
      declare_not_found
      return false
    end
    begin
      yield
    rescue ActiveRecord::RecordNotFound, NameError
      declare_not_found
      return false
    end
    true
  end

  def declare_not_found
    decl_str = "We couldn't find what you were looking for";
    respond_to do |format|
      format.html {
        flash[:error] = "#{decl_str} Why not try finding by name ?"
        redirect_to :action => :index
      }
      format.json {
        render :json => {:error => "#{decl_str}"}, :status => :not_found
      }
    end
  end

  def show
    if retrieve_inst then respond_with @inst else declare_not_found end
  end

  def edit
    declare_not_found unless retrieve_inst
    authorize_action_for @inst
  end

  def update
    declare_not_found unless retrieve_inst
    authorize_action_for @inst
    if @inst.update_attributes params[model_class.name.downcase.to_sym]
      respond_to do |format|
        format.html {
          flash[:success] = "Submission successful"
          redirect_to :action => :show
        }
        format.json {
          render :json => @inst
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Update failed"
          redirect_to :action => :edit
        }
        format.json {
          render :json => {
            :error => "Update failed",
            :details => @inst.errors
          }, :status => 500
        }
      end
    end
  end

  def destroy
    declare_not_found unless retrieve_inst
    authorize_action_for @inst

    if @inst.destroy
      respond_to do |format|
        format.html {
          flash[:success] = "Deletion successful"
          redirect_to :action => :index
        }
        format.json {
          render :json => {:success => "Deletion successful"}
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Deletion failed"
          redirect_to :action => :show
        }
        format.json {
          render :json => {:error => "Deletion failed"}, :status => 500
        }
      end
    end
  end

  def new
    @inst = model_class.new
  end

  def create
    mname = model_class.name.downcase.to_sym
    declare_not_found unless params.has_key? mname
    @inst = model_class.new params[mname]
    @inst.creator = current_user
    if @inst.save
      respond_to do |format|
        format.html {
          flash[:success] = "Creation successful"
          redirect_to :action => :show, :id => @inst.id
        }
        format.json {
          render :json => @inst
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Creation failed"
          redirect_to :action => :edit, :id => @inst.id
        }
        format.json {
          render :json => {:error => "Creation failed"}, :status => 500
        }
      end
    end
  end

end
