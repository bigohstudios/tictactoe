require 'csv'

class BoardStateWithResultOpponent
  PATH_TO_RAW_DATA = "/training_data/board_state_with_result.csv"

  def self.parse_raw_data_file
    inputs = []
    outputs = []
    rows = 0
    CSV.foreach(File.join(Rails.root,PATH_TO_RAW_DATA)) do |row|
      inputs  << (0...18).collect{|i| row[i].to_f}
      outputs << [row[18].to_f]
      rows += 1
    end

    {:inputs => inputs, :outputs => outputs, :samples => rows}
  end


  def self.ensure_trained
    if !@trained
      data = parse_raw_data_file 

#      puts data[:inputs].inspect
      train = RubyFann::TrainData.new(:inputs => data[:inputs], :desired_outputs => data[:outputs]) 
      @fann = RubyFann::Standard.new(:num_inputs=>18, :hidden_neurons=>[5,5], :num_outputs=>1)
      
      stop_func = @fann.get_train_stop_function
      out_num = @fann.get_num_output
      total_num = @fann.get_total_neurons
      trg_algorithm = @fann.get_training_algorithm
      
      puts "\n#{self} training ('#{trg_algorithm}' using '#{stop_func}' stop function with '#{out_num}' output neurons)...\n\n"
      #puts "\n#{self} training (using '#{stop_func}' stop function with '#{total_num}' total neurons)...\n\n"
      
      bit_fail_limit = @fann.get_bit_fail_limit
      puts "Bit fail limit: #{bit_fail_limit}"

      @fann.reset_MSE
      puts "Worst case 'Bit fail' = #{data[:samples] * out_num} (ie #{data[:samples]} samples * #{out_num} outputs)"
      @fann.train_on_data(train,100,10,0.1)
      
      puts "\n#{self} training finished!\n\n"
      
      @trained = true
    end

    yield
  end

  def self.get_move(board_state,current_player)
    # 4/7/14 DH: Inverts the board for player O (ie -1)
    board_state_input = board_state.as_input_array.collect{|s| s * current_player}

    ensure_trained do
      ###
      # 4/7/14 DH: This is the difference to 'board_state_only'
      # Make the "memo", ie 't', an array (by passing an empty array as argument) and take each "value", 
      # create a hash containing the NN output and add it to the array
      potential_moves = board_state.available_moves.inject([]) do |t,v|

        # Combine the arrays of the inverted (if necessary for 'O') current board and each available move 
        # (hence 18 inputs for the NN)
        net_input = [board_state_input,v].flatten
#        puts "considering: #{net_input.inspect}"
    
        # 30/7/14 DH: Run for each potential move to find the best (rather than just once for 'BoardStateOnlyOpponent')
        t << {:move => v, :fitness => @fann.run(net_input)[0]}
      end
      ###

      potential_moves.sort_by!{|move| move[:fitness]}.reverse!

#      puts potential_moves.inspect
      move = potential_moves[0][:move]
      #puts move.inspect
debugger
      # +1 because squares are numbered 1-9, but array index is 0-8
      square = move.index(1) + 1

#      puts "#{self} choosing #{square}: #{potential_moves.inspect}"

      "s#{square}"
    end
  end

end
