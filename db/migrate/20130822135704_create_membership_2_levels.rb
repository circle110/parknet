class CreateMembership2Levels < ActiveRecord::Migration
  def change
    create_table :membership_2_levels do |t|

      t.timestamps
    end
  end
end
