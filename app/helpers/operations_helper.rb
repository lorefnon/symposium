module OperationsHelper
  def operations_box target, is_subscribable=true
    render :partial => "application/operations_box",
    :locals => {:target => target, :is_subscribable => is_subscribable}
  end
end
