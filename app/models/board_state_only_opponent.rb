require 'csv'

class BoardStateOnlyOpponent
  PATH_TO_RAW_DATA = "/training_data/board_state_only.csv"

  def self.parse_raw_data_file
    inputs = []
    outputs = []
    rows = 0
    CSV.foreach(File.join(Rails.root,PATH_TO_RAW_DATA)) do |row|
      inputs  << (0...9).collect{|i| row[i].to_f}
      outputs << (9...18).collect{|i| row[i].to_f}
      rows += 1
    end
    
    # 2/7/14 DH: The training inputs contain -1,1 or 0 (ie containing PLAYER_MAP of 1 for X and -1 for O) 
    #            The training outputs only contain 1 or 0 (with only one row, row 10 of 30, containing two 1's)
    #            The output from '@fann.run(input)' is array of probabilities from 0 to 1

    {:inputs => inputs, :outputs => outputs, :samples => rows}
  end


  def self.ensure_trained
    if !@trained
      data = parse_raw_data_file 

      train = RubyFann::TrainData.new(:inputs => data[:inputs], :desired_outputs => data[:outputs]) 
      @fann = RubyFann::Standard.new(:num_inputs=>9, :hidden_neurons=>[5,5], :num_outputs=>9)
      
      stop_func = @fann.get_train_stop_function
      trg_algorithm = @fann.get_training_algorithm
      out_num = @fann.get_num_output
      total_num = @fann.get_total_neurons
      total_conn = @fann.get_total_connections
      
      puts "\n#{self} training ('#{trg_algorithm}' using '#{stop_func}' stop function with '#{out_num}' output neurons)...\n\n"
      #puts "\n#{self} training ('#{trg_algorithm}' using '#{stop_func}' stop function with '#{total_num}' total neurons)...\n\n"
      #puts "\n#{self} training (using '#{stop_func}' stop function with '#{total_conn}' total connections)...\n\n"
      #@fann.print_parameters
      
      @fann.reset_MSE
      puts "Worst case 'Bit fail' = #{data[:samples] * out_num} (ie #{data[:samples]} samples * #{out_num} outputs)"
      @fann.train_on_data(train,100,10,0.1)
      
      puts "\n#{self} training finished!\n\n"
      
      @trained = true
    end

    yield # to do-block in 'get_move'
  end

  def self.get_move(board_state,current_player)
    ensure_trained do # with 30 samples
    
      ##########################################################################################
      # MOVE = 1 * (NN SCORE FOR EACH SQUARE OF CURRENT BOARD) + TAKE HIGHEST NOT ALREADY TAKEN 
      ##########################################################################################

      input = (1...9).collect{|i| board_state.send("s#{i}")}
#      puts "INPUT: #{input.inspect}"

      # 30/7/14 DH: Run once with an input array of values for each square (like the training data input)
      #             This gives an output of 9 squares (due to NN cfg)
      output = @fann.run(input)
#      puts output.inspect

      sorted_moves = output.each_with_index.sort_by{|a| a[0]}.reverse!

      # 31/7/14 DH: Find empty square with best sorted_move
      # +1 because squares are numbered 1-9, but array index is 0-8
      square = sorted_moves.detect{|move_and_index| board_state.send("s#{move_and_index[1]+1}") == 0}
#debugger
#      puts "#{self} choosing #{square[1]}: #{sorted_moves.inspect}"

      "s#{square[1]+1}" # "s[1-9]=" passed to 'Game.take_turn' which is a setter method
    end
  end
end
