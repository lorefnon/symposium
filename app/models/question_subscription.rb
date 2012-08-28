class QuestionSubscription < Subscription
  belongs_to :target, :class_name => "Question"

  def notify_about_subscription
    notify Activity.create :description => "followed your question",
    :concerned_question => self.target,
    :subject => self.target
  end
end
