require 'csv'

class BoardStateWithResultTrg
  PATH_TO_RAW_DATA = "/training_data/board_state_with_result.csv"
  PATH_TO_WRITE = File.join(Rails.root,"training_data","board_state_with_resultALTERED.csv")

  def self.parse_raw_data_file
    inputs = []
    boards = []
    moves = []
    outputs = []
    
    rows = 0
    CSV.foreach(File.join(Rails.root,PATH_TO_RAW_DATA)) do |row|
      inputs  << (0...18).collect{|i| row[i].to_i}
      
      boards  << (0...9).collect{|i| row[i].to_i}
      moves  << (9...18).collect{|i| row[i].to_i}
      
      outputs << [row[18].to_i]
      rows += 1
    end

    {:inputs => inputs, :boards => boards, :moves => moves, :outputs => outputs, :samples => rows}
  end

  def self.sep_boards_moves_outputs(data)
    #csv = CSV.open(PATH_TO_WRITE, "w")
    file = File.open(PATH_TO_WRITE, "w")
    
    row = 0
    data[:boards].each do |board|
      move = data[:moves][row]
      output = data[:outputs][row]
      
      #puts "#{board.count},#{move.count},#{output.count}: #{board}, #{move}, #{output}"
      #puts board
      
      #csv << ["#{board}", "\t\t\t\t\t", "#{move}", "\t\t\t\t\t", "#{output}"]
      #csv << board + ["\t"] + move + ["\t"] + output
      
      string = ""
      board.each do |val|
        string << "#{val},"      
      end
      
      file << string.ljust(24)

      move.each do |val|
        file << "#{val},"      
      end
      
      file << "#{output[0]}\n".rjust(5)      

      row +=1
    end  
    
    file.close
    #csv.close
  end
    
end

namespace :data do

  desc 'Alters format of training data' 
  task :format => :environment do

    data = BoardStateWithResultTrg.parse_raw_data_file

    #puts "#{data[:inputs].first}"
    #puts "#{data[:boards].first}#{data[:moves].first}"

  #debugger
    BoardStateWithResultTrg.sep_boards_moves_outputs(data)
    
    puts "Lubbly, jubbly!"

  end

end

