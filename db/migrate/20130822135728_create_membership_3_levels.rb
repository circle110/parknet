class CreateMembership3Levels < ActiveRecord::Migration
  def change
    create_table :membership_3_levels do |t|

      t.timestamps
    end
  end
end
