require 'csv'

class BoardStateWithResultOpponent
  PATH_TO_RAW_DATA = "/training_data/board_state_with_result.csv"

  def self.parse_raw_data_file
    inputs = []
    outputs = []
    CSV.foreach(File.join(Rails.root,PATH_TO_RAW_DATA)) do |row|
      inputs  << (0...18).collect{|i| row[i].to_f}
      outputs << [row[18].to_f]
    end

    {:inputs => inputs, :outputs => outputs}
  end


  def self.ensure_trained
    if !@trained
      data = parse_raw_data_file 

      puts data[:inputs].inspect
      train = RubyFann::TrainData.new(:inputs => data[:inputs], :desired_outputs => data[:outputs]) 
      @fann = RubyFann::Standard.new(:num_inputs=>18, :hidden_neurons=>[5,5], :num_outputs=>1)
      @fann.train_on_data(train,1000,10,0.1)
      @trained = true
    end

    yield
  end

  def self.get_move(board_state,current_player)
    board_state_input = board_state.as_input_array.collect{|s| s * current_player}

    ensure_trained do
      potential_moves = board_state.available_moves.inject([]) do |t,v|
        net_input = [board_state_input,v].flatten
        puts "considering: #{net_input.inspect}"

        t << {:move => v, :fitness => @fann.run(net_input)[0]}
      end

      potential_moves.sort_by!{|move| move[:fitness]}.reverse!

      puts potential_moves.inspect
      move = potential_moves[0][:move]
      puts move.inspect

      # +1 because squares are numbered 1-9, but array index is 0-8
      square = move.index(1) + 1

#      puts "Choosing #{square}: #{potential_moves.inspect}"

      "s#{square}"
    end
  end

end
