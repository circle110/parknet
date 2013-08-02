module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Productive Parks ParkNet Application"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  #def error_messages_for (object)
	#render(:partial => 'shared/error_messages', :locals => {:object => object})
  #end
  
   def get_days_of_week(class_session_id)
	class_session = ClassSession.where(:id => class_session_id)
	days_of_week = ""
	class_session.first.sunday == 1 ? days_of_week += "Sun. " : nil
	class_session.first.monday == 1 ? days_of_week += "Mon. " : nil
	class_session.first.tuesday == 1 ? days_of_week += "Tue. " : nil
	class_session.first.wednesday == 1 ? days_of_week += "Wed. " : nil
	class_session.first.thursday == 1 ? days_of_week += "Thu. " : nil
	class_session.first.friday == 1 ? days_of_week += "Fri. " : nil
	class_session.first.saturday == 1 ? days_of_week += "Sat. " : nil
	return days_of_week
  end
  
end

