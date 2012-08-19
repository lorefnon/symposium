class OpinionsController < ApplicationController
  before_filter :authenticate_user!
  def create
    begin
      target_class = Kernel.const_get(params[:target_type])
    rescue NameError
      return declare_not_found "#{params[:target_type]} was not recognized"
    end

    unless target_class.include? Opinable::InstanceMethods
      return declare_not_found "There is no provision for registering opinion about #{params[:target_type].pluralize}"
    end

    return unless protect_against_missing :target_id do
      @target = target_class.find(params[:target_id])
    end

    o = Opinion.for(@target).by(current_user)
    unless o.nil?
      declare_permission_denied "Your opinion about this item has already been registered"
    end

    o = Opinion.new
    o.target = @target
    o.target_type = params[:target_type]
    o.creator = current_user
    o.optype = params[:optype]
    o.score_change = 0
    o.save
    redirect_to :back unless @done_rendering
    @done_rendering = true
  end
end
