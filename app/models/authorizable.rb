module Authorizable

  def is_editable_by? user
    true
  end

  def is_viewable_by? user
    true
  end

  def is_destroyable_by? user
    true
  end

  def is_updatable_by? user
    true
  end

end
