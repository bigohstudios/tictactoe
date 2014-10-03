class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :random
      t.integer :state
      t.integer :statewithresult
      t.string :first

      t.timestamps
    end
  end
end
