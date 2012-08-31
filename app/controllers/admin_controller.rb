class AdminController < ApplicationController
  before_filter :ensure_admin

  def dashboard
    params[:page] ||= 1
    @tags = Tag.paginate :page => params[:page]
    if params.has_key? :main_tag_id
      @main_tag = Tag.find params[:main_tag_id]
    else
      @main_tag = @tags[0]
    end
  end

  private

  def ensure_admin
    @inst = User.find params[:id]
    not @inst.nil? and @inst.role == "admin"
  end

end
