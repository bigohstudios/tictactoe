class AddSelfColumnToResults < ActiveRecord::Migration
  def change
    add_column :results, :self, :integer
  end
end
