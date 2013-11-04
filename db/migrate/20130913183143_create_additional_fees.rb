class CreateAdditionalFees < ActiveRecord::Migration
  def change
    create_table :additional_fees do |t|

      t.timestamps
    end
  end
end
