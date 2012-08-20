class SubscriptionsController < SymposiumBaseController
  before_filter :authenticate_user! , :except => [:index, :show]
  authorize_actions_for Subscription
  def create
    unless params.has_key? :subscription
      respond_to do |format|
        err_str = "Subscription details not found"
        format.html {
          flash[:error] = err_str
          # redirect_to :back
          render :text =>  params.to_json.to_s
          return
        }
        format.json {
          render :json => {:success => false, :errors => [err_str]}
        }
      end
    end

    s = Subscription.new params[:subscription]

    if params.has_key? :user_id
      begin
        s.subscriber = User.find params[:member_id]
      rescue ActiveRecord::RecordNotFound
        respond_to do |format|
          err_str = "Invalid subscriber"
          format.html {
            flash[:error] = err_str
            redirect_to "/"
            return
          }
          format.json {
            render :json => {:success => false, :errors => [err_str]}
          }
        end
      end
    else
      s.subscriber = current_user
    end

    if s.save
      respond_to do |format|
        format.html {
          flash[:success] = "Subscription confirmed"
          redirect_to :back
          return
        }
        format.json {
          render :json => {:success => true}
        }
      end

    else
      respond_to do |format|
        format.html {
          flash[:error] = "Could not subscribe"
          redirect_to :back
        }
        format.json {
          render :json => {:success => false, :details => s.errors}
        }
      end
    end
  end

end
