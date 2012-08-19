module SubscriptionsHelper
  def subscribe_button target

    render :partial => "subscriptions/subscribe_button",
    :locals => { :target => target }

  end
end
