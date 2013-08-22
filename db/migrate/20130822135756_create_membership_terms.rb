class CreateMembershipTerms < ActiveRecord::Migration
  def change
    create_table :membership_terms do |t|

      t.timestamps
    end
  end
end
