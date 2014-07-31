class Game < ActiveRecord::Base
  # 3/6/14 DH: Creating a results table to analyse the NN
  belongs_to :result
  
  has_many :board_states, :inverse_of => :game

  after_create :make_first_state

  PLAYER_TYPES = [
    'Human',
    'RandomOpponent',
    'BoardStateOnlyOpponent',
    'BoardStateWithResultOpponent'
  ]

  PLAYER_MAP = {
    1  => 'X',
    -1 => 'O'
  }
  
  # 4/6/14 DH: Ruby constants begin with a capital letter and have global scope within the class
  PLAYER_RESULTS_MAP = {
    'RandomOpponent'               => 'random',
    'BoardStateOnlyOpponent'       => 'state',
    'BoardStateWithResultOpponent' => 'statewithresult'
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

  # Processes all turns until a human's input is required
  def process_ai_turns!

    current_player_type = send("player_#{PLAYER_MAP[current_player].downcase}")

    until current_player_type == 'Human' || over?
      ai_opponent = current_player_type.classify.constantize
      self.board_states.reload
      take_turn( ai_opponent.get_move(self.current_state,self.current_player) )
      current_player_type = send("player_#{PLAYER_MAP[current_player].downcase}")
    end
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

  # 4/6/14 DH: Keep results to analyse NN stats
  def update_scoreboard!
    #line_item.create_bsc_req!(width: 20, drop: 20, lining: "You", heading: "Beauty")
    
    players = PLAYER_MAP.clone
    resultsHash = Hash.new
    
    # 5/6/14 DH: Send is a really nice feature of Ruby.  It allows the method to be determined at run-time (a bit like assigning a function pointer in C)
    #            "player_x" is the name of one of the inputs in the HTML form created by 'views/games/_form.html.haml'
    #            It is then whitelisted as a 'strong_parameter' by 'GamesController#game_params' and hence given an accessor method
    resultsHash['first'] = PLAYER_RESULTS_MAP[send("player_x")]

    if(game_outcome == 0)
      puts "Draw for:"
      playerIdx = 0
      players.keys.each do |key|
        players[playerIdx] = send("player_#{players[key].downcase}")
        puts players[playerIdx]
        resultsHash[PLAYER_RESULTS_MAP[players[playerIdx]]] = 0
        
        playerIdx += 1
      end
      if ( players[0].eql?(players[1]) )
        puts "Self draw for #{players[0]}"
        resultsHash[:self] = 0        
      end
      
    else
      winner = send("player_#{players[game_outcome].downcase}")
      puts "Winner is #{winner}"
      
      resultsHash[PLAYER_RESULTS_MAP[winner]] = 1
      
      players.delete(game_outcome)
      
      looser = send("player_#{players[players.keys.first].downcase}")
      puts "Looser is #{looser}"
      
      # 7/6/14 DH: For a self game then this will overwrite the win previously assigned above!
      if ( winner.eql?(looser) )
#debugger
        # 7/6/14 DH: Now need to decide whether the first (ID:player column=1) or second won (ID:self column=1).
        
        # Already deleted the winner so we only have the looser left
        if(players[players.keys.first].downcase == "o") # ie Looser went second
          # Already assigned 'player column=1'
          resultsHash["self"] = 0
          puts "Self game for #{winner} who started"
        else
          resultsHash[PLAYER_RESULTS_MAP[winner]] = 0
          resultsHash["self"] = 1
          puts "Self game for #{winner} who went second"
        end

      else
        resultsHash[PLAYER_RESULTS_MAP[looser]] = 0
      end
    end
    
    #create_result(random: ?, state: ?, statewithresult: ?)
    #puts "Calling 'create_result' with #{resultsHash}"
    create_result(resultsHash)
    # 4/6/14 DH: Need to save the FK table (after creating a row in the PK table) to store the FK
    save

  end

  def declare_draw!
    self.update_attributes(:game_outcome => 0)

    # 4/6/14 DH: Keep results to analyse NN stats
    update_scoreboard!
  end

  def declare_victory!(player_number,pattern)
    self.update_attributes(:game_outcome => player_number, :victory_pattern => pattern.join(','))
    
    # 4/6/14 DH: Keep results to analyse NN stats
    update_scoreboard!
  end

  def over?
    !game_outcome.nil?
  end

  def draw?
    over? && game_outcome == 0
  end

  # 1  = x (or X)
  # -1 = y (or O)
  
  # 4/6/14 DH: X always starts since (0 % 2 == 0)
  def current_player
    current_turn_index % 2 == 0 ? 1 : -1
  end

  private

  def make_first_state
    board_states.create
  end
end
