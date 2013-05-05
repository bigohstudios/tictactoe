# This opponent randomly picks a square that's available
class RandomOpponent
  def self.get_move(board_state)
    move = rand_square

    until board_state.send(move) == 0
      move  = rand_square
    end

    move
  end

  def rand_square
    "s#{rand(1..9)}"
  end
end
