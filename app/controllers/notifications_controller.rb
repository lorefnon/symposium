class NotificationsController < SymposiumBaseController
  def index
    return unless protect_against_missing :member_id do
      @user = User.find params[:member_id]
      authorize_action_for @user
    end
    @notifications = @user.notifications
    respond_with @notifications
    return
  end

  def destroy
  end

  def update
  end
end
