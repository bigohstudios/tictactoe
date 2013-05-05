require 'csv'

class BoardStateOnlyLoader
  PATH_TO_FILE = "/training_data/board_state_only.csv"

  def self.parse_file
    inputs = []
    outputs = []
    CSV.foreach(File.join(Rails.root,PATH_TO_FILE)) do |row|
      input = []
      (0...9).each do |i|
        input << row[i].to_f
      end
      inputs << input

      output = []
      (9...18).each do |i|
        output << row[i].to_f
      end
      outputs << output
    end

    {:inputs => inputs, :outputs => outputs}
  end
end
