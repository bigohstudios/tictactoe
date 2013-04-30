class CreateBoardStates < ActiveRecord::Migration
  def change
    create_table :board_states do |t|
      t.integer :game_id
      t.integer :turn_index, :default => 0
      t.integer :s1, :default => 0 
      t.integer :s2, :default => 0
      t.integer :s3, :default => 0
      t.integer :s4, :default => 0
      t.integer :s5, :default => 0
      t.integer :s6, :default => 0
      t.integer :s7, :default => 0
      t.integer :s8, :default => 0
      t.integer :s9, :default => 0

      t.timestamps
    end
  end
end
