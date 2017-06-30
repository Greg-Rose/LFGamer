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

ActiveRecord::Schema.define(version: 20170620184324) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "consoles", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_consoles_on_name", unique: true
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.string "cover_image", null: false
    t.boolean "online", null: false
    t.boolean "split_screen", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_games_on_name", unique: true
  end

  create_table "games_consoles", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "console_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["console_id"], name: "index_games_consoles_on_console_id"
    t.index ["game_id"], name: "index_games_consoles_on_game_id"
  end

end
