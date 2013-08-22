class CreateMembership1Levels < ActiveRecord::Migration
  def change
    create_table :membership_1_levels do |t|

      t.timestamps
    end
  end
end
