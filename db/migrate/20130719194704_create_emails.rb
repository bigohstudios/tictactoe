class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string   :filename
      t.float :character_count, :default => 0.0
      t.float :alpha_numeric_count, :default => 0.0
      t.float :alpha_numeric_ratio, :default => 0.0
      t.float :digit_count, :default => 0.0
      t.float :whitespace_count, :default => 0.0

      ('a'..'z').each do |letter|
        t.float "#{letter}_count", :default => 0.0
      end

      t.float :asterisk_count, :default => 0.0
      t.float :underscore_count, :default => 0.0
      t.float :plus_count, :default => 0.0
      t.float :equals_count, :default => 0.0
      t.float :percent_count, :default => 0.0
      t.float :dollar_sign_count, :default => 0.0
      t.float :at_count, :default => 0.0
      t.float :minus_count, :default => 0.0
      t.float :backslash_count, :default => 0.0
      t.float :slash_count, :default => 0.0
      t.float :word_count, :default => 0.0
      t.float :short_word_count, :default => 0.0
      t.float :average_word_length, :default => 0.0
      t.float :average_sentence_character_length, :default => 0.0
      t.float :average_sentence_word_length, :default => 0.0

      (1..15).each do |length| 
        t.float "words_of_length_#{length}_ratio", :default => 0.0
      end

      t.float :number_of_unique_words, :default => 0.0
      t.float :once_occuring_words_freq, :default => 0.0
      t.float :twice_occuring_words_freq, :default => 0.0

      t.float :period_count, :default => 0.0
      t.float :tick_count, :default => 0.0
      t.float :semicolon_count, :default => 0.0
      t.float :question_mark_count, :default => 0.0
      t.float :exclamation_mark_count, :default => 0.0
      t.float :colon_count, :default => 0.0
      t.float :left_paren_count, :default => 0.0
      t.float :right_paren_count, :default => 0.0
      t.float :dash_count, :default => 0.0
      t.float :quotation_mark_count, :default => 0.0
      t.float :left_double_arrow_count, :default => 0.0
      t.float :right_double_arrow_count, :default => 0.0
      t.float :less_than_count, :default => 0.0
      t.float :greater_than_count, :default => 0.0
      t.float :left_bracket_count, :default => 0.0
      t.float :right_bracket_count, :default => 0.0
      t.float :left_brace_count, :default => 0.0
      t.float :right_brace_count, :default => 0.0
      t.boolean :is_training
      t.boolean :is_ham # when set on a non-is_training row, it came from the NN

      t.timestamps
    end
  end
end
