module Notifier
  def notify_about operation, config = {}
    verb_past = config[:past]
    verb_past ||= "#{operation}d"
    notif_time = config[:notif_time]
    notif_time ||= "after"

    define_method "notify_about_#{operation}" do
      notify Activity.create :subject => self,
      :description => verb_past
    end

    __send__ "#{notif_time}_#{operation}", "notify_about_#{operation}"
  end
end
