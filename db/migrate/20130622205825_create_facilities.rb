class CreateFacilities < ActiveRecord::Migration
  def change
    create_table :facilities do |t|
	  t.integer :agency_id, :null => false
	  t.integer :facility_type_id, :null => false
	  t.integer :facility_supervisor_id 
	  t.string :name, :limit => 40, :null => false
	  t.integer :parent_facility_id
	  t.integer :gl_account_id
	  t.integer :user_stamp, :null => false
	  t.boolean :internet_query_flag
	  t.boolean :deposit_required_flag
	  t.boolean :internet_availability_flag
	  t.boolean :active, :null => false
	  t.integer :deposit_amount
	  t.text :alert_text
	  t.text :confirmation_text
	  t.text :descritption
      t.timestamps
    end
  end
end
