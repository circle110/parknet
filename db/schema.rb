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

  create_table "account_contacts", :force => true do |t|
    t.integer  "agency_id",                           :null => false
    t.integer  "account_id",                          :null => false
    t.integer  "seq_counter",                         :null => false
    t.string   "contact_name",         :limit => 100, :null => false
    t.integer  "priority",                            :null => false
    t.string   "contact_relationship", :limit => 40
    t.string   "home_area",            :limit => 3
    t.string   "home_phone",           :limit => 12
    t.string   "business_area",        :limit => 3
    t.string   "business_phone",       :limit => 12
    t.string   "business_ext",         :limit => 5
    t.string   "cell_area",            :limit => 3
    t.string   "cell_phone",           :limit => 12
    t.integer  "user_stamp",                          :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "account_contacts", ["account_id"], :name => "account_id"
  add_index "account_contacts", ["agency_id"], :name => "agency_id", :unique => true
  add_index "account_contacts", ["user_stamp"], :name => "user_stamp"

  create_table "accounting_transactions", :force => true do |t|
    t.integer  "agency_id",            :null => false
    t.integer  "transaction_type_id",  :null => false
    t.integer  "reference_id"
    t.integer  "debit_gl_account_id",  :null => false
    t.integer  "credit_gl_account_id", :null => false
    t.integer  "customer_account_id",  :null => false
    t.float    "debit",                :null => false
    t.float    "credit",               :null => false
    t.integer  "user_stamp",           :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "accounting_transactions", ["agency_id"], :name => "agency"
  add_index "accounting_transactions", ["credit_gl_account_id"], :name => "credit_gl"
  add_index "accounting_transactions", ["debit_gl_account_id"], :name => "debit_gl"

  create_table "accounts", :force => true do |t|
    t.integer  "agency_id",                                                                          :null => false
    t.string   "account_status_id",   :limit => 1,                                  :default => "a", :null => false
    t.string   "email",               :limit => 100,                                                 :null => false
    t.string   "hashed_password",     :limit => 40,                                                  :null => false
    t.string   "salt",                :limit => 40,                                                  :null => false
    t.string   "barcode_number",      :limit => 15
    t.string   "address",             :limit => 75,                                                  :null => false
    t.string   "address_2",           :limit => 75
    t.integer  "city_id"
    t.string   "state",               :limit => 2,                                                   :null => false
    t.integer  "zip",                                                                                :null => false
    t.string   "home_area",           :limit => 3
    t.string   "home_phone",          :limit => 12
    t.string   "resident_flag",       :limit => 1,                                  :default => "0", :null => false
    t.decimal  "future_balance",                     :precision => 10, :scale => 0
    t.decimal  "unallocated_balance",                :precision => 10, :scale => 0
    t.integer  "email_private",       :limit => 1
    t.text     "alert_text"
    t.integer  "user_stamp",                                                                         :null => false
    t.datetime "created_at",                                                                         :null => false
    t.datetime "updated_at",                                                                         :null => false
  end

  add_index "accounts", ["agency_id"], :name => "agency"
  add_index "accounts", ["city_id"], :name => "city"
  add_index "accounts", ["user_stamp"], :name => "user_stamp"

  create_table "addresses", :force => true do |t|
    t.integer  "agency_id",                :null => false
    t.string   "address1",   :limit => 45
    t.string   "address2",   :limit => 75
    t.integer  "city_id"
    t.string   "state",      :limit => 3
    t.string   "zip",        :limit => 10
    t.integer  "area_id"
    t.integer  "user_stamp",               :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "addresses", ["agency_id"], :name => "agency_id"
  add_index "addresses", ["user_stamp"], :name => "user_stamp"

  create_table "agencies", :force => true do |t|
    t.string   "name",                       :limit => 30
    t.string   "address",                    :limit => 50
    t.string   "city",                       :limit => 30
    t.string   "state",                      :limit => 2
    t.string   "zip",                        :limit => 10
    t.string   "phone",                      :limit => 16
    t.string   "fax",                        :limit => 16
    t.string   "registration_email",         :limit => 30
    t.string   "current_online_session_id",  :limit => 10
    t.text     "registration_dates_verbage"
    t.string   "url"
    t.string   "pdf_url"
    t.integer  "user_stamp",                               :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "agencies", ["user_stamp"], :name => "user_stamp"

  create_table "brochure_sections", :force => true do |t|
    t.integer  "agency_id",                 :null => false
    t.string   "name",        :limit => 40, :null => false
    t.integer  "active",      :limit => 1
    t.string   "description"
    t.integer  "user_stamp",                :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "brochure_sections", ["agency_id"], :name => "agency_id"
  add_index "brochure_sections", ["user_stamp"], :name => "user_stamp"

  create_table "brochure_subsections", :force => true do |t|
    t.integer  "brochure_section_id",               :null => false
    t.integer  "agency_id",                         :null => false
    t.string   "name",                :limit => 40, :null => false
    t.integer  "active",              :limit => 1
    t.string   "description"
    t.integer  "user_stamp",                        :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "brochure_subsections", ["agency_id"], :name => "agency"
  add_index "brochure_subsections", ["brochure_section_id"], :name => "parent_brochure_section"
  add_index "brochure_subsections", ["user_stamp"], :name => "user_stamp"

  create_table "cities", :force => true do |t|
    t.integer  "agency_id",                :null => false
    t.string   "name",       :limit => 45
    t.integer  "active",     :limit => 1,  :null => false
    t.integer  "user_stamp",               :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "cities", ["agency_id"], :name => "agency_id"
  add_index "cities", ["user_stamp"], :name => "user_stamp"

  create_table "class_session_fees", :force => true do |t|
    t.integer  "agency_id",                                                     :null => false
    t.integer  "class_session_id",                                              :null => false
    t.decimal  "amount",                         :precision => 10, :scale => 3
    t.string   "name",             :limit => 40,                                :null => false
    t.integer  "active",           :limit => 1,                                 :null => false
    t.string   "resident_type",    :limit => 1,                                 :null => false
    t.string   "member_type",      :limit => 1
    t.integer  "user_stamp",                                                    :null => false
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  add_index "class_session_fees", ["agency_id"], :name => "agency_id"
  add_index "class_session_fees", ["class_session_id"], :name => "class_session_id"
  add_index "class_session_fees", ["user_stamp"], :name => "user_stamp"

  create_table "class_sessions", :force => true do |t|
    t.integer  "agency_id",                                          :null => false
    t.integer  "program_id",                                         :null => false
    t.integer  "season_id",                                          :null => false
    t.string   "name",                                 :limit => 60
    t.integer  "session_display_order",                              :null => false
    t.string   "session_status_id",                    :limit => 1,  :null => false
    t.integer  "facility_id"
    t.date     "start_date"
    t.date     "end_date"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "sunday",                               :limit => 1
    t.integer  "monday",                               :limit => 1
    t.integer  "tuesday",                              :limit => 1
    t.integer  "wednesday",                            :limit => 1
    t.integer  "thursday",                             :limit => 1
    t.integer  "friday",                               :limit => 1
    t.integer  "saturday",                             :limit => 1
    t.integer  "number_of_bookings"
    t.integer  "supervisor_id"
    t.date     "registration_start_datetime",                        :null => false
    t.integer  "minimum_registrants",                                :null => false
    t.integer  "maximum_registrants",                                :null => false
    t.integer  "number_registered"
    t.integer  "number_waitlisted"
    t.datetime "cancel_datetime"
    t.string   "cancel_reason"
    t.integer  "user_stamp",                                         :null => false
    t.integer  "gl_account_id",                                      :null => false
    t.integer  "deferred_gl_account_id"
    t.integer  "minimum_age"
    t.integer  "maximum_age"
    t.string   "minimum_age_type",                     :limit => 1
    t.string   "maximum_age_type",                     :limit => 1
    t.date     "internet_display_date"
    t.date     "internet_display_until_date"
    t.date     "member_registration_start_date"
    t.date     "non_resident_registration_start_date"
    t.text     "alert_text"
    t.text     "confirmation_text"
    t.text     "description"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  add_index "class_sessions", ["agency_id"], :name => "agency"
  add_index "class_sessions", ["deferred_gl_account_id"], :name => "deferred_gl"
  add_index "class_sessions", ["facility_id"], :name => "facility_id"
  add_index "class_sessions", ["gl_account_id"], :name => "gl_account"
  add_index "class_sessions", ["program_id"], :name => "program_id"
  add_index "class_sessions", ["season_id"], :name => "season"
  add_index "class_sessions", ["supervisor_id"], :name => "supervisor"
  add_index "class_sessions", ["user_stamp"], :name => "user_stamp"

  create_table "customers", :force => true do |t|
    t.integer  "agency_id",                                                 :null => false
    t.integer  "account_id",                                                :null => false
    t.integer  "head_of_household_flag",   :limit => 1,    :default => 0
    t.string   "barcode_number",           :limit => 15
    t.string   "last_name",                :limit => 40
    t.string   "first_name",               :limit => 40
    t.string   "status_id",                :limit => 1,    :default => "a", :null => false
    t.string   "email",                    :limit => 50
    t.integer  "birthdate_alternative_id"
    t.string   "work_area",                :limit => 3
    t.string   "work_phone",               :limit => 12
    t.string   "work_ext",                 :limit => 5
    t.string   "home_area",                :limit => 3
    t.string   "home_phone",               :limit => 12
    t.string   "cell_area",                :limit => 3
    t.string   "cell_phone",               :limit => 12
    t.datetime "birthdate"
    t.string   "gender_id",                :limit => 1
    t.float    "current_account_balance",                  :default => 0.0, :null => false
    t.integer  "school_grade"
    t.integer  "email_private_flag",       :limit => 1
    t.datetime "initial_join_date"
    t.datetime "continuous_member_date"
    t.datetime "deceased_date"
    t.string   "alert_text",               :limit => 4000
    t.integer  "disabled_flag",            :limit => 1,    :default => 0,   :null => false
    t.integer  "user_stamp",                                                :null => false
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  add_index "customers", ["account_id"], :name => "account_id"
  add_index "customers", ["agency_id"], :name => "agency_id"
  add_index "customers", ["user_stamp"], :name => "user_stamp"

  create_table "facilities", :force => true do |t|
    t.integer  "agency_id",                                               :null => false
    t.integer  "facility_type_id",                                        :null => false
    t.integer  "facility_supervisor_id"
    t.string   "name",                       :limit => 40,                :null => false
    t.integer  "parent_facility_id",                       :default => 0
    t.integer  "gl_account_id"
    t.integer  "user_stamp",                                              :null => false
    t.boolean  "internet_query_flag"
    t.boolean  "deposit_required_flag"
    t.boolean  "internet_availability_flag"
    t.boolean  "active",                                                  :null => false
    t.float    "deposit_amount",             :limit => 11
    t.text     "alert_text"
    t.text     "confirmation_text"
    t.text     "description"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  add_index "facilities", ["agency_id"], :name => "agency_id"
  add_index "facilities", ["facility_supervisor_id"], :name => "facility_supervisor_id"
  add_index "facilities", ["facility_type_id"], :name => "facility_type_id"
  add_index "facilities", ["gl_account_id"], :name => "gl_account"
  add_index "facilities", ["parent_facility_id"], :name => "parent_facility"
  add_index "facilities", ["user_stamp"], :name => "user_stamp"

  create_table "facility_bookings", :force => true do |t|
    t.integer  "agency_id",                     :null => false
    t.integer  "facility_id",                   :null => false
    t.integer  "class_session_id",              :null => false
    t.date     "date",                          :null => false
    t.time     "start_time",                    :null => false
    t.time     "end_time",                      :null => false
    t.string   "booking_type_id",  :limit => 1, :null => false
    t.text     "notes"
    t.integer  "user_stamp",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facility_bookings", ["agency_id"], :name => "agency_id"
  add_index "facility_bookings", ["class_session_id"], :name => "class_session_id"
  add_index "facility_bookings", ["facility_id"], :name => "facility_id"
  add_index "facility_bookings", ["user_stamp"], :name => "user_stamp"

  create_table "facility_types", :force => true do |t|
    t.integer  "agency_id",                :null => false
    t.string   "name",       :limit => 75
    t.integer  "user_stamp",               :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "facility_types", ["agency_id"], :name => "agency_id"
  add_index "facility_types", ["user_stamp"], :name => "user_stamp"

  create_table "funds", :force => true do |t|
    t.integer  "agency_id",                :null => false
    t.integer  "fund",                     :null => false
    t.string   "name",       :limit => 40, :null => false
    t.integer  "active",     :limit => 1,  :null => false
    t.integer  "user_stamp",               :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "funds", ["agency_id"], :name => "agency_id"
  add_index "funds", ["user_stamp"], :name => "user_stamp"

  create_table "gl_accounts", :force => true do |t|
    t.integer  "agency_id",                        :null => false
    t.integer  "fund_id",                          :null => false
    t.string   "name",              :limit => 40,  :null => false
    t.string   "gl_account_number", :limit => 200, :null => false
    t.integer  "account_type",                     :null => false
    t.integer  "active",            :limit => 1
    t.integer  "user_stamp",                       :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "gl_accounts", ["agency_id"], :name => "agency_id"
  add_index "gl_accounts", ["fund_id"], :name => "fund_id"
  add_index "gl_accounts", ["user_stamp"], :name => "user_stamp"

  create_table "membership_1_levels", :force => true do |t|
    t.integer  "agency_id",                    :null => false
    t.string   "name",                         :null => false
    t.integer  "multi_member",    :limit => 1, :null => false
    t.integer  "member_quantity",              :null => false
    t.integer  "resident",        :limit => 1, :null => false
    t.integer  "age_based",       :limit => 1, :null => false
    t.integer  "minimum_age",                  :null => false
    t.integer  "maximum_age",                  :null => false
    t.integer  "subscription",    :limit => 1, :null => false
    t.integer  "active",          :limit => 1, :null => false
    t.integer  "user_stamp",                   :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "membership_1_levels", ["agency_id"], :name => "agency_id"

  create_table "membership_2_levels", :force => true do |t|
    t.integer  "agency_id",                    :null => false
    t.string   "name",                         :null => false
    t.integer  "multi_member",    :limit => 1, :null => false
    t.integer  "member_quantity",              :null => false
    t.integer  "resident",        :limit => 1, :null => false
    t.integer  "age_based",       :limit => 1, :null => false
    t.integer  "minimum_age",                  :null => false
    t.integer  "maximum_age",                  :null => false
    t.integer  "subscription",    :limit => 1, :null => false
    t.integer  "active",          :limit => 1, :null => false
    t.integer  "user_stamp",                   :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "membership_2_levels", ["agency_id"], :name => "agency_id"

  create_table "membership_3_levels", :force => true do |t|
    t.integer  "agency_id",                    :null => false
    t.string   "name",                         :null => false
    t.integer  "multi_member",    :limit => 1, :null => false
    t.integer  "member_quantity",              :null => false
    t.integer  "resident",        :limit => 1, :null => false
    t.integer  "age_based",       :limit => 1, :null => false
    t.integer  "minimum_age",                  :null => false
    t.integer  "maximum_age",                  :null => false
    t.integer  "subscription",    :limit => 1, :null => false
    t.integer  "active",          :limit => 1, :null => false
    t.integer  "user_stamp",                   :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "membership_3_levels", ["agency_id"], :name => "agency_id"

  create_table "membership_terms", :force => true do |t|
    t.integer  "agency_id",                :null => false
    t.string   "name",                     :null => false
    t.integer  "term_length",              :null => false
    t.string   "term_units",  :limit => 2, :null => false
    t.integer  "user_stamp",               :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "membership_terms", ["agency_id"], :name => "agency_id"

  create_table "memberships", :force => true do |t|
    t.integer  "agency_id",                       :null => false
    t.string   "name",                            :null => false
    t.integer  "level_1_id",                      :null => false
    t.integer  "level_2_id",                      :null => false
    t.integer  "level_3_id",                      :null => false
    t.integer  "membership_term_id"
    t.integer  "subscription_flag",  :limit => 1
    t.integer  "active",             :limit => 1, :null => false
    t.integer  "user_stamp",                      :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "memberships", ["agency_id", "level_1_id", "level_2_id", "level_3_id", "membership_term_id"], :name => "agency_id"

  create_table "payment_allocations", :force => true do |t|
    t.integer  "agency_id",       :null => false
    t.integer  "payment_id",      :null => false
    t.integer  "allocation_type", :null => false
    t.integer  "reference_id",    :null => false
    t.float    "amount",          :null => false
    t.integer  "user_stamp",      :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "payment_allocations", ["agency_id", "payment_id"], :name => "agency_id"

  create_table "payments", :force => true do |t|
    t.integer  "agency_id",                         :null => false
    t.integer  "account_id",                        :null => false
    t.integer  "location_id",                       :null => false
    t.integer  "payment_type_id",                   :null => false
    t.float    "amount",                            :null => false
    t.string   "stripe_token",        :limit => 40
    t.string   "check_number",        :limit => 20
    t.integer  "canceled",            :limit => 1
    t.integer  "creation_user_stamp",               :null => false
    t.integer  "user_stamp",                        :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "payments", ["agency_id", "location_id", "user_stamp"], :name => "agency_id"
  add_index "payments", ["creation_user_stamp"], :name => "creation_user_stamp"

  create_table "programs", :force => true do |t|
    t.integer  "agency_id",                                      :null => false
    t.integer  "brochure_section_id"
    t.integer  "brochure_subsection_id"
    t.string   "code",                            :limit => 10,  :null => false
    t.string   "name",                            :limit => 100, :null => false
    t.integer  "min_age"
    t.string   "min_age_type",                    :limit => 1
    t.integer  "max_age"
    t.string   "max_age_type",                    :limit => 1
    t.integer  "default_minimum_registrants"
    t.integer  "default_maximum_registrants"
    t.boolean  "scheduled_payments_allowed_flag",                :null => false
    t.integer  "deferred_gl_account_id"
    t.integer  "user_stamp"
    t.boolean  "internet_query_flag"
    t.binary   "photo"
    t.boolean  "daycare_flag"
    t.boolean  "internet_registration_flag"
    t.boolean  "include_in_tax_receipt_flag"
    t.boolean  "active"
    t.text     "alert_text"
    t.text     "confirmation_text"
    t.text     "description"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "programs", ["agency_id"], :name => "agency"
  add_index "programs", ["brochure_section_id"], :name => "brochure_section"
  add_index "programs", ["brochure_subsection_id"], :name => "brochure_subsection"
  add_index "programs", ["deferred_gl_account_id"], :name => "deferred_gl"
  add_index "programs", ["user_stamp"], :name => "user_stamp"

  create_table "registration_basket_line_items", :force => true do |t|
    t.integer  "registration_basket_id", :null => false
    t.integer  "class_session_id",       :null => false
    t.integer  "user_stamp",             :null => false
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "registration_basket_line_items", ["class_session_id"], :name => "class_session_id"
  add_index "registration_basket_line_items", ["registration_basket_id"], :name => "registration_basket_id"

  create_table "registration_baskets", :force => true do |t|
    t.integer  "agency_id",   :null => false
    t.integer  "customer_id", :null => false
    t.integer  "status",      :null => false
    t.integer  "user_stamp",  :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "registration_baskets", ["agency_id", "customer_id"], :name => "agency_id"
  add_index "registration_baskets", ["customer_id"], :name => "customer_id"

  create_table "registrations", :force => true do |t|
    t.integer  "agency_id",                                         :null => false
    t.integer  "customer_id",                                       :null => false
    t.integer  "class_session_id",                                  :null => false
    t.string   "status_id",           :limit => 1, :default => "a"
    t.float    "fee_amount",                                        :null => false
    t.float    "unpaid_balance",                   :default => 0.0, :null => false
    t.integer  "creation_user_stamp",                               :null => false
    t.integer  "payment_plan_id"
    t.datetime "withdraw_datetime"
    t.integer  "user_stamp",                                        :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  create_table "season_titles", :force => true do |t|
    t.integer  "agency_id",                :null => false
    t.string   "title",      :limit => 40, :null => false
    t.integer  "active",     :limit => 1,  :null => false
    t.integer  "user_stamp",               :null => false
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "season_titles", ["agency_id"], :name => "agency"
  add_index "season_titles", ["user_stamp"], :name => "user_stamp"

  create_table "seasons", :force => true do |t|
    t.integer  "agency_id",                                       :null => false
    t.string   "season_year",                        :limit => 4, :null => false
    t.integer  "season_title_id",                                 :null => false
    t.datetime "default_registration_start_date",                 :null => false
    t.integer  "active",                             :limit => 1, :null => false
    t.datetime "default_internet_display_date"
    t.datetime "default_nr_registration_start_date"
    t.datetime "member_registration_start_date",                  :null => false
    t.datetime "registration_start_time",                         :null => false
    t.integer  "user_stamp",                                      :null => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "seasons", ["agency_id"], :name => "agency_id"
  add_index "seasons", ["season_title_id"], :name => "season_title"
  add_index "seasons", ["user_stamp"], :name => "user_stamp"

  create_table "staff_supervisor", :force => true do |t|
    t.integer  "agency_id",     :null => false
    t.integer  "staff_user_id", :null => false
    t.integer  "user_stamp",    :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "staff_supervisor", ["agency_id"], :name => "agency_id"
  add_index "staff_supervisor", ["staff_user_id"], :name => "staff_user_id"
  add_index "staff_supervisor", ["user_stamp"], :name => "user_stamp"

  create_table "staff_users", :force => true do |t|
    t.integer  "agency_id",                                    :null => false
    t.string   "first_name",      :limit => 40
    t.string   "last_name",       :limit => 40
    t.string   "email",           :limit => 60,                :null => false
    t.string   "hashed_password", :limit => 40
    t.string   "salt",            :limit => 40,                :null => false
    t.integer  "security_group",                               :null => false
    t.integer  "is_supervisor",   :limit => 1,  :default => 0, :null => false
    t.integer  "user_stamp",                                   :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "staff_users", ["agency_id"], :name => "agency_id"
  add_index "staff_users", ["email"], :name => "unique_login", :unique => true
  add_index "staff_users", ["user_stamp"], :name => "user_stamp"

end
