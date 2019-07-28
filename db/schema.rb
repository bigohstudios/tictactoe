# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130719194704) do

  create_table "board_states", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "turn_index", default: 0
    t.integer  "s1",         default: 0
    t.integer  "s2",         default: 0
    t.integer  "s3",         default: 0
    t.integer  "s4",         default: 0
    t.integer  "s5",         default: 0
    t.integer  "s6",         default: 0
    t.integer  "s7",         default: 0
    t.integer  "s8",         default: 0
    t.integer  "s9",         default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", force: :cascade do |t|
    t.string   "filename"
    t.float    "character_count",                   default: 0.0
    t.float    "alpha_numeric_count",               default: 0.0
    t.float    "alpha_numeric_ratio",               default: 0.0
    t.float    "digit_count",                       default: 0.0
    t.float    "whitespace_count",                  default: 0.0
    t.float    "a_count",                           default: 0.0
    t.float    "b_count",                           default: 0.0
    t.float    "c_count",                           default: 0.0
    t.float    "d_count",                           default: 0.0
    t.float    "e_count",                           default: 0.0
    t.float    "f_count",                           default: 0.0
    t.float    "g_count",                           default: 0.0
    t.float    "h_count",                           default: 0.0
    t.float    "i_count",                           default: 0.0
    t.float    "j_count",                           default: 0.0
    t.float    "k_count",                           default: 0.0
    t.float    "l_count",                           default: 0.0
    t.float    "m_count",                           default: 0.0
    t.float    "n_count",                           default: 0.0
    t.float    "o_count",                           default: 0.0
    t.float    "p_count",                           default: 0.0
    t.float    "q_count",                           default: 0.0
    t.float    "r_count",                           default: 0.0
    t.float    "s_count",                           default: 0.0
    t.float    "t_count",                           default: 0.0
    t.float    "u_count",                           default: 0.0
    t.float    "v_count",                           default: 0.0
    t.float    "w_count",                           default: 0.0
    t.float    "x_count",                           default: 0.0
    t.float    "y_count",                           default: 0.0
    t.float    "z_count",                           default: 0.0
    t.float    "asterisk_count",                    default: 0.0
    t.float    "underscore_count",                  default: 0.0
    t.float    "plus_count",                        default: 0.0
    t.float    "equals_count",                      default: 0.0
    t.float    "percent_count",                     default: 0.0
    t.float    "dollar_sign_count",                 default: 0.0
    t.float    "at_count",                          default: 0.0
    t.float    "minus_count",                       default: 0.0
    t.float    "backslash_count",                   default: 0.0
    t.float    "slash_count",                       default: 0.0
    t.float    "word_count",                        default: 0.0
    t.float    "short_word_count",                  default: 0.0
    t.float    "average_word_length",               default: 0.0
    t.float    "average_sentence_character_length", default: 0.0
    t.float    "average_sentence_word_length",      default: 0.0
    t.float    "words_of_length_1_ratio",           default: 0.0
    t.float    "words_of_length_2_ratio",           default: 0.0
    t.float    "words_of_length_3_ratio",           default: 0.0
    t.float    "words_of_length_4_ratio",           default: 0.0
    t.float    "words_of_length_5_ratio",           default: 0.0
    t.float    "words_of_length_6_ratio",           default: 0.0
    t.float    "words_of_length_7_ratio",           default: 0.0
    t.float    "words_of_length_8_ratio",           default: 0.0
    t.float    "words_of_length_9_ratio",           default: 0.0
    t.float    "words_of_length_10_ratio",          default: 0.0
    t.float    "words_of_length_11_ratio",          default: 0.0
    t.float    "words_of_length_12_ratio",          default: 0.0
    t.float    "words_of_length_13_ratio",          default: 0.0
    t.float    "words_of_length_14_ratio",          default: 0.0
    t.float    "words_of_length_15_ratio",          default: 0.0
    t.float    "number_of_unique_words",            default: 0.0
    t.float    "once_occuring_words_freq",          default: 0.0
    t.float    "twice_occuring_words_freq",         default: 0.0
    t.float    "period_count",                      default: 0.0
    t.float    "tick_count",                        default: 0.0
    t.float    "semicolon_count",                   default: 0.0
    t.float    "question_mark_count",               default: 0.0
    t.float    "exclamation_mark_count",            default: 0.0
    t.float    "colon_count",                       default: 0.0
    t.float    "left_paren_count",                  default: 0.0
    t.float    "right_paren_count",                 default: 0.0
    t.float    "dash_count",                        default: 0.0
    t.float    "quotation_mark_count",              default: 0.0
    t.float    "left_double_arrow_count",           default: 0.0
    t.float    "right_double_arrow_count",          default: 0.0
    t.float    "less_than_count",                   default: 0.0
    t.float    "greater_than_count",                default: 0.0
    t.float    "left_bracket_count",                default: 0.0
    t.float    "right_bracket_count",               default: 0.0
    t.float    "left_brace_count",                  default: 0.0
    t.float    "right_brace_count",                 default: 0.0
    t.boolean  "is_training"
    t.boolean  "is_ham"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_turn_index", default: 0
    t.integer  "game_outcome"
    t.string   "player_x"
    t.string   "player_o"
    t.string   "victory_pattern"
  end

end
