class SymposiumBaseController < ApplicationController
  respond_to :html, :json

  before_filter :ensure_resource_exists, :except => [:new, :create, :index]
  before_filter :setup_flash

  private

  def model_class_name; controller_name.classify end
  def model_class; model_class_name.constantize end

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

  def declare_permission_denied msg = "Operation not permitted"
    respond_to do |format|
      format.html {
        flash[:error] = msg
        redirect_to :back
      }
      format.json {
        render :json => {:error => msg}, :status => 403
      }
    end
    @done_rendering = true
  end

  def declare_not_found decl_str = "One or more requested resource(s) not found"
    respond_to do |format|
      format.html {
        flash[:error] = decl_str
        redirect_to :back
      }
      format.json {
        render :json => {:error => decl_str}, :status => :not_found
      }
    end
    @done_rendering = true
  end

  def ensure_resource_exists
    unless retrieve_inst
      declare_not_found
      return false
    end
    true
  end

  public

  def show
    respond_with @inst
  end

  def edit
    authorize_action_for @inst
  end

  def update
    authorize_action_for @inst
    gen_updation_response( @inst.update_attributes( params[model_class.name.downcase.to_sym]))
  end

  def destroy
    authorize_action_for @inst
    gen_deletion_response( @inst.destroy )
  end

  def new
    @inst = model_class.new
  end

  def create
    mname = model_class.name.downcase.to_sym
    declare_not_found unless params.has_key? mname
    @inst = model_class.new params[mname]
    @inst.creator = current_user
    gen_creation_response( @inst.save )
  end

  private

  def setup_flash
    flash[:aux_errors] ||= []
  end

  def gen_creation_failure_response
    msg = @msg || "Creation failed"
    details = @details || []
    status = @status || 403
    respond_to do |format|
      format.html {
        flash[:error] = msg
        flash[:aux_errors] += details
        redirect_to(:back) and return
      }
      format.json {
        render :json => {:error => msg, :details => details}, :status => status
      }
    end
    @done_rendering = true
  end

  def gen_creation_success_response
    msg = @msg || "Creation successful"
    details = @details || []
    respond_to do |format|
      format.html {
        flash[:success] = msg
        flash[:aux_errors] += details
        redirect_to(:action => :show, :id => @inst.id) and return
      }
      format.json {
        render :json => @inst
      }
    end
    @done_rendering = true
  end

  def gen_updation_failure_response
    msg = @msg || "Update failed."
    details = @details || []
    status = @status || 403
    respond_to do |format|
      format.html {
        flash[:error] = msg,
        flash[:aux_errors] += details
        redirect_to :back
      }
      format.json {
        render :json => {:error => msg, :details => details}, :status => status
      }
    end
    @done_rendering = true
  end

  def gen_updation_success_response
    msg = @msg || "Update successful"
    details = @details || []
    respond_to do |format|
      format.html {
        flash[:success] = msg
        flash[:aux_errors] += details
        redirect_to :action => :show
      }
      format.json {
        render :json => @inst
      }
    end
    @done_rendering = true
  end

  def gen_deletion_success_response
    msg = @msg || "Deletion successful."
    details = @details || []
    respond_to do |format|
      format.html {
        flash[:success] = msg
        flash[:aux_errors] += details
        redirect_to :back
      }
      format.json {
        render :json => {:success => msg }
      }
    end
    @done_rendering = true
  end

  def gen_deletion_failure_response
    msg = @msg || "Deletion failed."
    details = @details || []
    status = @status || 403
    respond_to do |format|
      format.html {
        flash[:error] = msg
        redirect_to :back
      }
      format.json {
        render :json => {:error => msg, :details => details}, :status => status
      }
    end
    @done_rendering = true
  end

  verb_axn_mapper = {
    :create => :creation,
    :update => :updation,
    :destroy => :deletion,
  }

  verb_axn_mapper.each do |verb, axn|
    # All gen_axn_response functions will delegate to user
    # defined gen_axn_success_response or gen_axn_failure_response
    # whichever is appropriate
    define_method "gen_#{axn}_response" do |success|
      status = if success then "success" else "failure" end
      self.send "gen_#{axn}_#{status}_response" unless @done_rendering
    end
  end
end
