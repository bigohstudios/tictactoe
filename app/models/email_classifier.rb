class EmailClassifier
  NUM_INPUTS = 82 # taken from Rails console.  Update if you change the inputs
  class << self
    def train
      inputs  = []
      outputs = []

      Email.where(:is_training => true).each do |email|
        inputs  << email_record_to_array(email)
        outputs << [email.is_ham ? 1 : -1]
      end
      puts outputs.inspect

      training_data = RubyFann::TrainData.new(:inputs => inputs, :desired_outputs => outputs)
      @fann = RubyFann::Standard.new(:num_inputs => 82, :hidden_neurons => [5,5], :num_outputs => 1)
      @fann.train_on_data(training_data,1000,10,0.1)
    end

    def classify_emails
      Email.where(:is_training => false).each do |email|
        result = @fann.run(email_record_to_array(email))
        puts "#{email.filename}: #{result.inspect}"
      end
    end

    # Converts the db record into an array of inputs
    def email_record_to_array(db_record)
      retval = []

      retval << db_record.character_count
      retval << db_record.alpha_numeric_count
      retval << db_record.alpha_numeric_ratio
      retval << db_record.digit_count
      retval << db_record.whitespace_count

      ('a'..'z').each do |letter|
        retval << db_record.send("#{letter}_count")
      end

      retval << db_record.asterisk_count
      retval << db_record.underscore_count
      retval << db_record.plus_count
      retval << db_record.equals_count
      retval << db_record.percent_count
      retval << db_record.dollar_sign_count
      retval << db_record.at_count
      retval << db_record.minus_count
      retval << db_record.backslash_count
      retval << db_record.slash_count
      retval << db_record.word_count
      retval << db_record.short_word_count
      retval << db_record.average_word_length
      retval << db_record.average_sentence_character_length
      retval << db_record.average_sentence_word_length

      (1..15).each do |length| 
        retval << db_record.send("words_of_length_#{length}_ratio")
      end

      retval << db_record.number_of_unique_words
      retval << db_record.once_occuring_words_freq
      retval << db_record.twice_occuring_words_freq

      retval << db_record.period_count
      retval << db_record.tick_count
      retval << db_record.semicolon_count
      retval << db_record.question_mark_count
      retval << db_record.exclamation_mark_count
      retval << db_record.colon_count
      retval << db_record.left_paren_count
      retval << db_record.right_paren_count
      retval << db_record.dash_count
      retval << db_record.quotation_mark_count
      retval << db_record.left_double_arrow_count
      retval << db_record.right_double_arrow_count
      retval << db_record.less_than_count
      retval << db_record.greater_than_count
      retval << db_record.left_bracket_count
      retval << db_record.right_bracket_count
      retval << db_record.left_brace_count
      retval << db_record.right_brace_count

      retval
    end
  end
end
