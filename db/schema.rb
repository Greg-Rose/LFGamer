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

ActiveRecord::Schema.define(version: 20171102004341) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "consoles", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "igdb_id"
    t.index ["name"], name: "index_consoles_on_name", unique: true
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id"
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.string "cover_image", null: false
    t.boolean "online", null: false
    t.boolean "split_screen", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "igdb_id"
    t.datetime "last_release_date"
    t.index ["name"], name: "index_games_on_name", unique: true
  end

  create_table "games_consoles", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "console_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "release_date"
    t.index ["console_id"], name: "index_games_consoles_on_console_id"
    t.index ["game_id"], name: "index_games_consoles_on_game_id"
  end

  create_table "lfgs", force: :cascade do |t|
    t.bigint "ownership_id"
    t.string "specifics"
    t.boolean "show_console_username", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ownership_id"], name: "index_lfgs_on_ownership_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "conversation_id"
    t.bigint "user_id"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "ownerships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "games_console_id"
    t.boolean "current", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["games_console_id"], name: "index_ownerships_on_games_console_id"
    t.index ["user_id"], name: "index_ownerships_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "about_me"
    t.string "psn_id"
    t.string "xbox_gamertag"
    t.string "zipcode", limit: 5
    t.boolean "psn_id_public", default: false
    t.boolean "xbox_gamertag_public", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "username", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "deleted_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
