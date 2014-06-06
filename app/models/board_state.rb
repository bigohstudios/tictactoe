class BoardState < ActiveRecord::Base
  belongs_to :game, :inverse_of => :board_states

  scope :ordered, -> { order(turn_index: :desc) }

  def copy
    b = BoardState.new

    (1..9).each do |i|
      b.send("s#{i}=", self.send("s#{i}"))
    end

    b.game_id = game.id
    b.turn_index = turn_index

    b
  end

  def available_moves
    available_spaces = (1..9).collect{|i| send("s#{i}") == 0 ? 1 : 0}

    moves = []
    available_spaces.each_with_index do |val,i|
      #puts val
      if val == 1
        move = []

        i.times{|n| move << 0}
        move << 1
        (available_spaces.length-i-1).times{|n| move << 0}

        moves << move
      end
    end

    moves
  end

  def as_input_array
    (1..9).collect{|i| send("s#{i}")}
  end
end
