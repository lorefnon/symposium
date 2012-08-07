module DeactivatorHelper
  def login_reqd_btn label, url, class_names = ""
    dis = if user_signed_in? then "" else "disabled login-disabled" end
    title = if user_signed_in? then label else "Login Required" end
    "<a href='#{url}' class='btn #{class_names} #{dis}' title='#{title}'> #{label} </a>"
  end
end
