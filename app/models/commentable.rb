module Commentable
  def is_commentable
    has_many :comments,
    :as => :target,
    :dependent => :destroy

    has_many :commenters,
    :through => :comments,
    :source => :creator

    include InstanceMethods
  end

  module InstanceMethods
    def commentable?
      true
    end
  end

end

ActiveRecord::Base.extend Commentable
