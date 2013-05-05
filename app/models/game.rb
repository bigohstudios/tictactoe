class Game < ActiveRecord::Base
  has_many :board_states, :inverse_of => :game

  after_create :make_first_state

  PLAYER_TYPES = [
    'Human',
    'RandomOpponent',
    'ComputerOne',
    'ComputerTwo'
  ]

  PLAYER_MAP = {
    1  => 'X',
    -1 => 'O' 
  }

  def state_for_square(square)
    if current_state
      current_state.send(square)
    else
      0
    end
  end

  def current_state
    board_states.ordered.first || nil
  end

  # ignoring verifying valid square
  def take_turn(square)
    new_state = current_state.copy

    new_state.send("#{square}=", current_player)
    new_state.turn_index += 1
    new_state.attributes.delete(:id)
    new_state.save

    self.update_attributes :current_turn_index => new_state.turn_index

    check_for_victory!

    true
  rescue Exception => e # so evil...
    false
  end

  VICTORY_COMBINATIONS = [
    # horizontal
    ['s1','s2','s3'],
    ['s4','s5','s6'],
    ['s7','s8','s9'],
    # diagonal
    ['s1','s5','s9'],
    ['s3','s5','s7'],
    # vertical
    ['s1','s4','s7'],
    ['s2','s5','s8'],
    ['s3','s6','s9']
  ]

  def check_for_victory!
    if current_turn_index == 9
      declare_draw!
    else
      VICTORY_COMBINATIONS.each do |pattern|
        if current_state.send(pattern[0]) != 0 &&
           current_state.send(pattern[0]) == current_state.send(pattern[1]) &&
           current_state.send(pattern[0]) == current_state.send(pattern[2])

          declare_victory!(current_state.send(pattern[0]),pattern)
        end
      end
    end
  end

  def declare_draw!
    self.update_attributes(:game_outcome => 0)
  end

  def declare_victory!(player_number,pattern)
    self.update_attributes(:game_outcome => player_number, :victory_pattern => pattern.join(','))
  end

  def over?
    !game_outcome.nil?
  end

  def draw?
    over? && game_outcome == 0
  end

  # 1  = x
  # -1 = y
  def current_player
    current_turn_index % 2 == 0 ? 1 : -1
  end

  private

  def make_first_state
    board_states.create
  end
end
