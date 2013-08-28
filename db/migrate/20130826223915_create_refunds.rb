class CreateRefunds < ActiveRecord::Migration
  def change
    create_table :refunds do |t|

      t.timestamps
    end
  end
end
