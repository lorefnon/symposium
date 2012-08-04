module Opinable
  def is_opinable
    has_many :opinions,
    :as => :target,
    :dependent => :destroy

    has_many :upvotes,
    :class_name => "Opinion",
    :conditions => {:action => "upvote"}

    has_many :downvotes,
    :class_name => "Opinion",
    :conditions => {:action => "downvote"}

    has_many :flags,
    :class_name => "Opinion",
    :conditions => {:action => "flag"}

    has_many :opiners,
    :through => :opinions,
    :source => :creator

    has_many :upvoters,
    :through => :upvotes,
    :source => :creator

    has_many :downvotes,
    :through => :downvotes,
    :source => :creator

    has_many :flaggers,
    :through => :flags,
    :source => :creator
  end

  module InstanceMethods
    def opinable?
      true
    end
  end

end

ActiveRecord::Base.extend Opinable
