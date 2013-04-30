class AddCurrentTurnIndexToGames < ActiveRecord::Migration
  def change
    add_column :games, :current_turn_index, :integer, :default => 0
    add_column :games, :game_outcome, :integer
  end
end
