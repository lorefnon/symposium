class TagSubscription < Subscription
  belongs_to :target, :class_name => "Tag"

  def notify_about_subscription
    # no need to notify anyone
  end
end
