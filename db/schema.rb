# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130622224516) do

  create_table "facilities", :force => true do |t|
    t.integer  "agency_id",                                :null => false
    t.integer  "facility_type_id",                         :null => false
    t.integer  "facility_supervisor_id"
    t.string   "name",                       :limit => 40, :null => false
    t.integer  "parent_facility_id"
    t.integer  "gl_account_id"
    t.integer  "user_stamp",                               :null => false
    t.boolean  "internet_query_flag"
    t.boolean  "deposit_required_flag"
    t.boolean  "internet_availability_flag"
    t.boolean  "active",                                   :null => false
    t.integer  "deposit_amount"
    t.text     "alert_text"
    t.text     "confirmation_text"
    t.text     "descritption"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "programs", :force => true do |t|
    t.integer  "brochure_section_id"
    t.integer  "brochure_subsection_id"
    t.string   "code",                            :limit => 10, :null => false
    t.string   "title",                           :limit => 60, :null => false
    t.integer  "min_age"
    t.string   "min_age_type",                    :limit => 1
    t.integer  "max_age"
    t.string   "max_age_type",                    :limit => 1
    t.integer  "default_minimun_registrants"
    t.integer  "default_maximun_registrants"
    t.boolean  "scheduled_payments_allowed_flag",               :null => false
    t.integer  "deferred_gl_account_id"
    t.integer  "user_stamp"
    t.boolean  "internet_query_flag"
    t.boolean  "daycare_flag"
    t.boolean  "internet_registration_flag"
    t.boolean  "include_in_tax_receipt_flag"
    t.boolean  "active"
    t.text     "alert_text"
    t.text     "confirmation_text"
    t.text     "descritption"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "sessions", :force => true do |t|
    t.integer  "program_id",                                         :null => false
    t.integer  "season_id",                                          :null => false
    t.string   "title",                                :limit => 60
    t.integer  "session_display_order",                              :null => false
    t.string   "session_status_id",                                  :null => false
    t.integer  "facility_id"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "number_of_bookings"
    t.integer  "supervisor_id"
    t.date     "registration_start_datetime",                        :null => false
    t.integer  "minimum_registrants",                                :null => false
    t.integer  "maximum_registrants",                                :null => false
    t.integer  "number_registered",                                  :null => false
    t.integer  "number_waitlisted",                                  :null => false
    t.datetime "cancel_datetime"
    t.string   "cancel_reason"
    t.integer  "user_stamp",                                         :null => false
    t.integer  "gl_account_id",                                      :null => false
    t.integer  "deferred_gl_account_id"
    t.integer  "minimum_age"
    t.integer  "maximum_age"
    t.integer  "minimum_age_type"
    t.integer  "maximum_age_type"
    t.date     "internet_dislpay_date"
    t.date     "internet_display_date"
    t.date     "internet_display_until_date"
    t.date     "member_registration_start_date"
    t.date     "non_resident_registration_start_date"
    t.text     "alert_text"
    t.text     "confirmation_text"
    t.text     "descritption"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

end
