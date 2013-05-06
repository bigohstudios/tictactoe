require 'csv'

# Takes completed games and turns them into training data for the Board StateWithResult opponent
class BoardStateWithResultConverter
  PATH_TO_WRITE = File.join(Rails.root,"training_data","board_state_with_result.csv")

  def self.go
    csv = CSV.open(PATH_TO_WRITE, "w")

    games = Game.where("game_outcome IS NOT NULL").all

    games.each do |game|
      current_player = 1 # always start with x
      game.board_states.each_with_index do |bs,i|
        break if i == game.board_states.length-1 # always takes at least 6 turns to win or draw

        bs_array = (1..9).collect{|s| bs.send("s#{s}").to_i}

        # Make sure all moves are from current_player's perspective
        normalized_bs_array = bs_array.collect{|state| state * current_player}

        # discover the move
        move_taken = 
          (1..9).collect do |s|
            if bs.send("s#{s}") != game.board_states[i+1].send("s#{s}")
              1
            else
              0
            end
          end

        #puts "(#{i+1}) MOVE TAKEN: #{move_taken.inspect}"

        full_input = [normalized_bs_array,move_taken,game.game_outcome*current_player].flatten

        current_player *= -1

        #puts "(#{i+1}) full input: #{full_input.inspect}"
        csv << full_input
      end
    end

    csv.close
  end

end
