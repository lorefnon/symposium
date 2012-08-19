module DeactivatorHelper
  def login_reqd_btn label, url, class_names = "", icon = nil
    dis = if user_signed_in? then "" else "disabled login-disabled" end
    title = if user_signed_in? then label else "Login Required" end
    render :partial => "application/login_reqd_btn",
    :locals => {
      :url => url, :class_names => class_names, :dis => dis,
      :title => title, :icon => icon, :label => label
    }
  end
end
