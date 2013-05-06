require 'csv'

class BoardStateOnlyOpponent
  PATH_TO_RAW_DATA = "/training_data/board_state_only.csv"

  def self.parse_raw_data_file
    inputs = []
    outputs = []
    CSV.foreach(File.join(Rails.root,PATH_TO_RAW_DATA)) do |row|
      inputs  << (0...9).collect{|i| row[i].to_f}
      outputs << (9...18).collect{|i| row[i].to_f}
    end

    {:inputs => inputs, :outputs => outputs}
  end


  def self.ensure_trained
    if !@trained
      data = parse_raw_data_file 

      train = RubyFann::TrainData.new(:inputs => data[:inputs], :desired_outputs => data[:outputs]) 
      @fann = RubyFann::Standard.new(:num_inputs=>9, :hidden_neurons=>[5,5], :num_outputs=>9)
      @fann.train_on_data(train,1000,10,0.1)
      @trained = true
    end

    yield
  end

  def self.get_move(board_state,current_player)
    ensure_trained do
      input = (1...9).collect{|i| board_state.send("s#{i}")}
#      puts "INPUT: #{input.inspect}"

      output = @fann.run(input)
      puts output.inspect

      sorted_moves = output.each_with_index.sort_by{|a| a[0]}.reverse!

      # +1 because squares are numbered 1-9, but array index is 0-8
      square = sorted_moves.detect{|move_and_index| board_state.send("s#{move_and_index[1]+1}") == 0}

#      puts "Choosing #{square[1]}: #{sorted_moves.inspect}"

      "s#{square[1]+1}"
    end
  end
end
