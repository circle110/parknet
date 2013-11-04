class ClassSession < ActiveRecord::Base
	belongs_to :agency
	belongs_to :program
	belongs_to :season
	belongs_to :staff_user
	belongs_to :facility
	has_many :facility_bookings
	belongs_to :gl_account
	belongs_to :deferred_gl_account
	has_many :class_session_fees
	has_many :registrations
	
	attr_accessible :agency_id, :program_id, :season_id, :name, :session_display_order, :session_status_id, :facility_id, :start_date, :end_date, 
	:start_time, :end_time, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :number_of_bookings, :supervisor_id, :registration_start_datetime,:minimum_registrants, :maximum_registrants, :number_registered, :number_waitlisted, :cancel_datetime, :cancel_reason, :gl_account_id, :deferred_gl_account_id, :minimum_age, :maximum_age, :minimum_age_type, :maximum_age_type, :internet_display_date, :internet_display_until_date, :member_registration_start_date, :non_resident_registration_start_date, :alert_text, :confirmation_text, :description, :user_stamp
	
	after_create :create_bookings
	
	def session_identifier
		return session_display_order.to_s + " - " + get_days_of_week + " - " + start_time.to_s + " - " + end_time.to_s
	end
	
	def get_days_of_week
		class_session = ClassSession.where(:id => id)
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
	
	def create_bookings
	
		# put days if week into dow array
		# see what dow the start date is
		# if it is not one of the days listed then reject the save
		# If it is one of the listed dow then
		# loop through and make bookings for every 7 days until a booking is beyond the end date
		# move to next dow
		# find next date of that dow following the start date
		# loop through and make bookings for every 7 days until a booking is beyond the end date
		# move to next dow on list and repeat until done
		
		dow = []
		sunday == 1 ? dow << 'Sunday' : nil
		monday == 1 ? dow << 'Monday' : nil
		tuesday == 1 ? dow << 'Tuesday' : nil
		wednesday == 1 ? dow << 'Wednesday' : nil
		thursday == 1 ? dow << 'Thursday' : nil
		friday == 1 ? dow << 'Friday' : nil
		saturday == 1 ? dow << 'Saturday' : nil
		
		first_dow = start_date.strftime("%A")

		if dow.include? first_dow
			booking_date = start_date.to_date
			while booking_date <= end_date.to_date
				booking = Booking.new(
				:agency_id => agency_id,
				:booking_date => booking_date,
				:start_time => start_time,
				:end_time => end_time,
				:facility_id => facility_id,
				:class_session_id => id,
				:user_stamp => user_stamp
				)
				if booking.save	
				   #all is good
				else
				   #generate error 
				end
				booking_date += 1.week
			end
		else
			#:flash => "Start date is not one of the days of week selected."
			#render(new)
		end

		dow.delete_if {|x| x == first_dow}

		dow.each do |d|
			next_day = start_date.to_date
			(0..6).each do |i|
				next_day += 1.days
				if next_day.strftime("%A") == d
					booking_date = next_day
					break
				end
			end
			
			while booking_date <= end_date.to_date do
				booking = Booking.new(
				:agency_id => agency_id,
				:booking_date => booking_date.to_s,
				:start_time => start_time.to_time,
				:end_time => end_time.to_time,
				:facility_id => facility_id,
				:class_session_id => id,
				:user_stamp => user_stamp
				)
				if booking.save	
				   #hooray
				else
				   #generate error 
				end
				booking_date = booking_date + 1.week
			end
		end
	
	end
	
end
