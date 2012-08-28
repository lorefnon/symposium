class AnswerSubscription < Subscription
  belongs_to :target, :class_name => "Answer"

  def notify_about_subscription
    notify Activity.create :description => "followed your answer for",
    :concerned_question => self.target.question,
    :subject => self.target
  end
end
