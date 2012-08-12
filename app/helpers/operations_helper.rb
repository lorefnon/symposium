module OperationsHelper
  def operations_box target
    render :partial => "application/operations_box",
    :locals => {:target => target}
  end
end
