class OpinionsController < ApplicationController
  before_filter :authenticate_user!

  def get_target
    begin
      target_class = Kernel.const_get(params[:target_type])
    rescue NameError
      @msg = "#{params[:target_type]} was not recognized"
      return false
    end

    unless target_class.include? Opinable::InstanceMethods
      @msg =  "There is no provision for registering opinion about #{params[:target_type].pluralize}"
      return false
    end
    unless params.has_key? :target_id
      @msg = "Identification of opinion target failed"
      return false
    end
    @target = target_class.find(params[:target_id])

    if @target.nil?
      @msg = "opinion target not found : class - #{target_class.name}, id - #{params[:target_id]}"
      return false
    end

    return true
  end

  def gen_failure
    respond_to do |format|
      format.html {
        flash[:error] = @msg
        redirect_to :back
      }
      format.json {
        render :json => {:error => @msg}, :status => 403
      }
    end
  end

  def gen_success
    respond_to do |format|
      format.html {
        flash[:success] = @msg
        redirect_to :back
      }
      format.json {
        render :json => {:success => @msg}
      }
    end
  end

  def set_params
    @opinion.target = @target
    @opinion.target_type = params[:target_type]
    @opinion.creator = current_user
    @opinion.optype = params[:optype]
    @opinion.score_change = 0
  end

  def update
    return gen_failure unless get_target
    @opinion = Opinion.for(@target).by(current_user).first

    if @opinion.nil?
      redirect_to :action => :create
    else
      @res = @opinion.save
      @msg = if @res then "opinion successfully updated"
             else "opinion could not be updated"
             end
      if @res then gen_success else gen_failure end
    end
  end

  def create
    return gen_failure unless get_target
    o = Opinion.for(@target).by(current_user).first

    unless o.nil?
      @msg = "An opinion has already been registered for this user"
      return gen_failure
    end

    @opinion = Opinion.new
    set_params
    res = @opinion.save
    @msg = if res then "opinion successfully registered"
           else "Opinion could not be registered"
           end
    if res then gen_success else gen_failure end
  end
end
