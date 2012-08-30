class UserSubscription < Subscription
  belongs_to :target, :class_name => "User"

  def notify activity
    Notification.create :user => self.target, :activity => activity
  end

  def notify_about_subscription
    notify Activity.create :description => "followed you.",
    :initiator => self.subscriber,
    :subject => self.target
  end
end
