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
end
