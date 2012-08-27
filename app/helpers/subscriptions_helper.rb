module SubscriptionsHelper
  def subscription_form target
    subs = Subscription.where({:target_id => target.id, :subscriber_id => current_user.id}).first
    if subs.nil?
      render :partial => "subscriptions/subscription_form",
      :locals => { :target => target }
    else
      render :partial => "subscriptions/subscription_withdrawl_form",
      :locals => { :id => subs.id }
    end
  end
  def subscription_chooser target_type
    render :partial => "subscription_chooser", :locals => { :target_type => @target_type }
  end
end
