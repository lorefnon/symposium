module Opinable
  def is_opinable
    has_many :opinions,
    :as => :target,
    :dependent => :destroy

    has_many :upvotes,
    :class_name => "Opinion",
    :as => :target,
    :conditions => {:optype => "upvote"}

    has_many :downvotes,
    :class_name => "Opinion",
    :as => :target,
    :conditions => {:optype => "downvote"}

    has_many :flags,
    :class_name => "Opinion",
    :as => :target,
    :conditions => {:optype => "flag"}

    has_many :opiners,
    :through => :opinions,
    :source => :creator

    has_many :upvoters,
    :through => :upvotes,
    :source => :creator

    has_many :downvoters,
    :through => :downvotes,
    :source => :creator

    has_many :flaggers,
    :through => :flags,
    :source => :creator

    include InstanceMethods
  end

  module InstanceMethods
    def opinable?
      true
    end
  end

end

ActiveRecord::Base.extend Opinable
