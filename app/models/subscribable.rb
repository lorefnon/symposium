module Subscribable

  def is_subscribable
    has_many :subscriptions, :as => :target
    has_many :subscribers, :through => :subscriptions
  end

  def InstanceMethods
    def subscribable?
      true
    end
  end
end

ActiveRecord::Base.extend Subscribable
