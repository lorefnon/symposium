class TagsController < SymposiumBaseController
  before_filter :authenticate_user!
  def add_moderator
    declare_permission_denied unless current_user.role == "admin"
    respond_to do |format|
      if params.has_key? :moderator_id
        @moderator = User.find params[:moderator_id]
      elsif params.has_key? :moderator_name
        @moderator = User.find_by_user_name params[:moderator_name]
      else
        @moderator = nil
      end
      if @moderator.nil?
        return declare_not_found
      end
      @moderator.role = "moderator"
      @inst.moderators << @moderator
      @moderator.save
      @inst.save
      format.html {
        flash[:success] = "Moderator added"
        redirect_to(:controller => :members, :action => :show, :id => @moderator.id)
      }
      format.json {
        render :json => {:success => true}
      }
    end
  end
  def remove_moderator
    declare_permission_denied unless current_user.role == "admin"
    respond_to do |format|
      protect_against_missing :moderator_id do
        mod = User.find params[:moderator_id]
        if @inst.moderators.delete mod
          msg = "Moderator successfully deleted"
          format.html {
            flash[:success] = msg
            redirect_to(:action => :show, :id => @inst.id) and return
          }
          format.json {
            render :json => {:success => true}
          }
        else
          msg = "Moderator could not be deleted"
          format.html {
            flash[:error] = msg
            redirect_to(:back) and return
          }
          format.json {
            render :json => {:success => false, :error => msg}
          }
        end
      end
    end
  end

  def index
    params[:page] ||= 1
    if params[:moderator_id] then index_for_moderator else index_gen end
  end

  def index_for_moderator
    @moderator = User.find params[:moderator_id]
    declare_not_found and return if @moderator.nil?
    @tags = @moderator.moderated_tags.paginate :page => params[:page]
  end

  def index_gen
    @tags = Tag.paginate :page => params[:page]
  end

end
