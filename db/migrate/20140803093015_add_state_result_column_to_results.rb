class AddStateResultColumnToResults < ActiveRecord::Migration
  def change
    add_column :results, :stateresult, :integer
  end
end
