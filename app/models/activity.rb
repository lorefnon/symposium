# == Schema Information
#
# Table name: activities
#
#  id           :integer          not null, primary key
#  subject_id   :integer
#  subject_type :integer
#  initiator_id :integer
#  description  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# An Activity instance corresponds to some activity performed
# by a user eg. creation of Question, creation of Answer, etc,
#
# Note: current message generator assumes desc to be a verb in
# past tense eg. created, deleted etc.
class Activity < ActiveRecord::Base
  attr_accessible :subject, :description, :subject, :initiator
  has_many :reputation_changes

  # Activities have many notifications which are directed
  # to multiple users. Unlike activities notifications are
  # user-specific in the sense they record information
  # like if a user has actually read the notification, or
  # what is the priority of notification for this user.
  #
  # Note : Currently no prioritization scheme is in place
  # And notifications are ordered just by creation time.
  has_many :notifications, :dependent => :destroy
  has_many :users, :through => :notifications
  belongs_to :subject, :polymorphic => true

  def metadata
    mdata = read_attribute(:metadata)
    if mdata.nil? then nil else ActiveSupport::JSON.decode(mdata) end
  end

  def metadata=(data)
    write_attribute :metadata, ActiveSupport::JSON.encode(data)
  end

  def subject=(subject)
    self.metadata = subject.get_summary
    super(subject)
  end
end
