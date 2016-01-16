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

ActiveRecord::Schema.define(version: 20160116185624) do

  create_table "game_stats", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.string   "game_name"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "draws"
    t.integer  "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "game_stats", ["game_id"], name: "index_game_stats_on_game_id"
  add_index "game_stats", ["user_id"], name: "index_game_stats_on_user_id"

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.string   "table_name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "leaderboards", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "game_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "leaderboards", ["game_id"], name: "index_leaderboards_on_game_id"

  create_table "mttt_games", force: :cascade do |t|
    t.string   "player1",        default: "---\n:id: \n:symbol: \n:pieces: 3\n"
    t.string   "player2",        default: "---\n:id: \n:symbol: \n:pieces: 3\n"
    t.string   "current_player"
    t.string   "board",          default: "---\n- - \n  - \n  - \n- - \n  - \n  - \n- - \n  - \n  - \n"
    t.boolean  "is_picking_up",  default: false
    t.boolean  "is_replacing",   default: false
    t.integer  "winner_id"
    t.boolean  "is_draw",        default: false
    t.string   "state"
    t.string   "message"
    t.string   "opponent"
    t.datetime "created_at",                                                                             null: false
    t.datetime "updated_at",                                                                             null: false
  end

  create_table "mttt_games_users", id: false, force: :cascade do |t|
    t.integer "user_id",      null: false
    t.integer "mttt_game_id", null: false
  end

  create_table "mttt_moves", force: :cascade do |t|
    t.string   "player"
    t.integer  "square_i"
    t.integer  "square_j"
    t.boolean  "is_picking_up", default: false
    t.boolean  "is_replacing",  default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "mttt_game_id"
  end

  add_index "mttt_moves", ["mttt_game_id"], name: "index_mttt_moves_on_mttt_game_id"

  create_table "ttt_games", force: :cascade do |t|
    t.string   "player1",        default: "---\n:id: \n:symbol: \n"
    t.string   "player2",        default: "---\n:id: \n:symbol: \n"
    t.string   "current_player", default: "---\n:id: \n:symbol: \n"
    t.string   "board",          default: "---\n- \n- \n- \n- \n- \n- \n- \n- \n- \n"
    t.integer  "winner_id"
    t.boolean  "is_draw",        default: false
    t.string   "state"
    t.string   "message"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.string   "opponent"
  end

  create_table "ttt_games_users", id: false, force: :cascade do |t|
    t.integer "user_id",     null: false
    t.integer "ttt_game_id", null: false
  end

  create_table "ttt_moves", force: :cascade do |t|
    t.integer  "ttt_game_id"
    t.string   "player",      default: "---\n:id: \n:symbol: \n"
    t.integer  "square"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "ttt_moves", ["ttt_game_id"], name: "index_ttt_moves_on_ttt_game_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "role"
    t.string   "username"
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
