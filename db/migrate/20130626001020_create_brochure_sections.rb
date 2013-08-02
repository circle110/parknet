class CreateBrochureSections < ActiveRecord::Migration
  def change
    create_table :brochure_sections do |t|

      t.timestamps
    end
  end
end
