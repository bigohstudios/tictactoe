# This opponent randomly picks a square that's available
class RandomOpponent
  def self.get_move(board_state,current_player)
    Rails.logger.debug "Moving with board state: #{board_state.inspect}"
    move = rand_square

    until board_state.send(move) == 0
      move  = rand_square
    end

    move
  end

  def self.rand_square
    "s#{rand(1..9)}"
  end
end
