class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
	  t.integer :brochure_section_id
	  t.integer :brochure_subsection_id	
	  t.string :code, :null => false, :limit => 10
	  t.string :title, :null => false, :limit => 60
	  t.integer :min_age
	  t.string :min_age_type, :limit => 1
	  t.integer :max_age
	  t.string :max_age_type, :limit => 1
	  t.integer :default_minimun_registrants
	  t.integer :default_maximun_registrants
	  t.boolean :scheduled_payments_allowed_flag, :null => false
	  t.integer :deferred_gl_account_id
	  t.integer :user_stamp
	  t.boolean :internet_query_flag
	  t.boolean :daycare_flag
	  t.boolean :internet_registration_flag
	  t.boolean :include_in_tax_receipt_flag
	  t.boolean :active
	  t.text :alert_text
	  t.text :confirmation_text
	  t.text :descritption
      t.timestamps
    end
  end
end
