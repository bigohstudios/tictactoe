class AddVictoryPatternToGames < ActiveRecord::Migration
  def change
    add_column :games, :victory_pattern, :string
  end
end
