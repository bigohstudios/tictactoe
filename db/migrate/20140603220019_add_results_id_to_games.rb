class AddResultsIdToGames < ActiveRecord::Migration
  def change
    add_reference :games, :result, index: true
  end
end
