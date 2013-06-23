class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
	  t.integer :program_id, :null => false
	  t.integer :season_id, :null => false
	  t.string :title, :limit => 60
	  t.integer :session_display_order, :null => false
	  t.string :session_status_id, :null => false
	  t.integer :facility_id
	  t.date :start_date
	  t.date :end_date
	  t.time :start_time
	  t.time :end_time
	  t.integer :number_of_bookings
	  t.integer :supervisor_id
	  t.date :registration_start_datetime, :null => false
	  t.integer :minimum_registrants, :null => false
	  t.integer :maximum_registrants, :null => false
	  t.integer :number_registered, :null => false
	  t.integer :number_waitlisted, :null => false
	  t.datetime :cancel_datetime
	  t.string :cancel_reason
	  t.integer :user_stamp, :null => false
	  t.integer :gl_account_id, :null => false
	  t.integer :deferred_gl_account_id
	  t.integer :minimum_age
	  t.integer :maximum_age
	  t.integer :minimum_age_type
	  t.integer :maximum_age_type
	  t.date :internet_dislpay_date
	  t.date :internet_display_date
	  t.date :internet_display_until_date
	  t.date :member_registration_start_date
	  t.date :non_resident_registration_start_date
	  t.string :cancel_reason
	  t.text :alert_text
	  t.text :confirmation_text
	  t.text :descritption
      t.timestamps
    end
  end
end
