class EmailProcessor
  TRAINING_DATA_DIR = File.join(Rails.root, 'spam', 'just_bodies','*')
  CLASSIFICATION_FILE = File.join(Rails.root, 'spam', 'SPAMTrain.label')
  TESTING_DATA_DIR  = File.join(Rails.root, 'spam', 'just_bodies_testing', '*')

  class << self
    # This version deletes all the records first
    def process!
      Email.delete_all

      process
    end

    def process
      classifications = {}
      classifications_data = File.read(CLASSIFICATION_FILE)
      classifications_data.gsub!(/\r\n?/, "\n")
      classifications_data.split("\n").each_with_index do |line,i|
        is_ham, filename = line.split
        classifications[filename] = is_ham == '1'
      end

      Dir[TRAINING_DATA_DIR].each do |file_path|
        email = process_one_email(true, file_path)
        email.is_ham = classifications[email.filename]
        email.save
      end

      Dir[TESTING_DATA_DIR].each do |file_path|
        process_one_email(false, file_path)
      end
    end

    def process_one_email(is_training, file_path)
      email = Email.new(:filename => File.basename(file_path))
      
      contents = ''
      File.open(file_path, 'r') do |file|
        contents = file.read
        contents.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
        contents.encode!('UTF-8', 'UTF-16')
      end
        
      no_whitespace  = contents.gsub(/\s+/,        '')
      alpha_numeric  = contents.gsub(/[^0-9a-z]/i, '')
      digits         = contents.gsub(/[^0-9]/i,    '')
      whitespace     = contents.gsub(/[^\s+]/,     '')
      all_lower      = contents.downcase
      all_words      = contents.split # this is a really bad word count, whatever, it's a proxy
      sentences      = contents.split('.')

      email.character_count     = contents.length
      email.alpha_numeric_count = alpha_numeric.length 
      email.alpha_numeric_ratio = email.alpha_numeric_count.to_f / email.character_count.to_f
      email.digit_count         = digits.length
      email.whitespace_count    = whitespace.length

      ('a'..'z').each do |letter|
        email.send("#{letter}_count=", all_lower.count(letter))
      end

      email.asterisk_count                    = contents.count('*')
      email.underscore_count                  = contents.count('_')
      email.plus_count                        = contents.count('+')
      email.equals_count                      = contents.count('=')
      email.percent_count                     = contents.count('%')
      email.dollar_sign_count                 = contents.count('$')
      email.at_count                          = contents.count('@')
      email.minus_count                       = contents.count('-')
      email.backslash_count                   = contents.count('\\')
      email.slash_count                       = contents.count('/')
      email.word_count                        = all_words.count
      email.short_word_count                  = all_words.inject(0){|t,word| t += 1 if word.length <= 2; t}
      email.average_word_length               = all_words.inject(0){|t,word| t += word.length; t} / all_words.length.to_f
      email.average_sentence_character_length = sentences.inject(0){|t,sentence| t += sentence.gsub(/\s+/, '').length; t} / sentences.length
      email.average_sentence_word_length      = sentences.inject(0){|t,sentence| t += sentence.split.length; t} / sentences.length

      word_lengths = {}
      word_counts = {}
      all_words.each do |word|
        use_length = [word.length,15].min
        word_lengths[use_length] ||= 0
        word_lengths[use_length] += 1

        word_counts[word] ||= 0
        word_counts[word] += 1
      end

      word_lengths.each_pair do |key,value|
        email.send("words_of_length_#{key}_ratio=", value / all_words.length.to_f)
      end

      email.number_of_unique_words = all_words.uniq.length

      hapax_legomenon = word_counts.reject{|k,v| v > 1}
      email.once_occuring_words_freq = hapax_legomenon.keys.length / all_words.length.to_f

      hapax_dislegomenon = word_counts.reject{|k,v| v != 2}
      email.twice_occuring_words_freq = hapax_dislegomenon.keys.length / all_words.length.to_f

      email.period_count             = contents.count('.')
      email.tick_count               = contents.count('\'')
      email.semicolon_count          = contents.count(';')
      email.question_mark_count      = contents.count('?')
      email.exclamation_mark_count   = contents.count('!')
      email.colon_count              = contents.count(':')
      email.left_paren_count         = contents.count('(')
      email.right_paren_count        = contents.count(')')
      email.dash_count               = contents.count('-')
      email.quotation_mark_count     = contents.count('"')
      email.left_double_arrow_count  = contents.count('«')
      email.right_double_arrow_count = contents.count('»')
      email.less_than_count          = contents.count('<')
      email.greater_than_count       = contents.count('>')
      email.left_bracket_count       = contents.count('[')
      email.right_bracket_count      = contents.count(']')
      email.left_brace_count         = contents.count('{')
      email.right_brace_count        = contents.count('}')
      email.is_training              = is_training
      email.save

      return email
    end
  end
end
