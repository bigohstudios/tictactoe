class AddPlayerXToGames < ActiveRecord::Migration
  def change
    add_column :games, :player_x, :string
    add_column :games, :player_o, :string
  end
end
