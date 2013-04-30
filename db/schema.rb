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

ActiveRecord::Schema.define(version: 20130430025938) do

  create_table "board_states", force: true do |t|
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

  create_table "games", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_turn_index", default: 0
    t.integer  "game_outcome"
    t.string   "player_x"
    t.string   "player_o"
    t.string   "victory_pattern"
  end

end
