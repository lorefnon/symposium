class OpinionsController < ApplicationController
  before_filter :authenticate_user!
  def create
    o = Opinion.new
    # [WARNING] Security breach
    target = Kernel.const_get(params[:target_type]).find(params[:target_id])
    o.target = target
    o.target_type = params[:target_type]
    o.creator = current_user
    o.optype = params[:optype]
    o.score_change = 0
    o.save
    redirect_to "/#{params[:target_type].downcase.pluralize}/#{params[:target_id]}"
  end
end
