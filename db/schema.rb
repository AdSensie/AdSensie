# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_19_151600) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "channels", force: :cascade do |t|
    t.string "telegram_id"
    t.string "username"
    t.string "title"
    t.text "description"
    t.integer "subscriber_count"
    t.integer "avg_views"
    t.decimal "avg_engagement_rate"
    t.decimal "growth_rate"
    t.decimal "post_frequency"
    t.datetime "last_synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avg_engagement_rate"], name: "index_channels_on_engagement"
    t.index ["created_at"], name: "index_channels_on_created_at"
    t.index ["growth_rate"], name: "index_channels_on_growth"
    t.index ["subscriber_count"], name: "index_channels_on_subscribers"
    t.index ["telegram_id"], name: "index_channels_on_telegram_id", unique: true
  end

  create_table "collection_channels", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.bigint "channel_id", null: false
    t.text "notes"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_collection_channels_on_channel_id"
    t.index ["collection_id"], name: "index_collection_channels_on_collection_id"
  end

  create_table "collections", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.bigint "telegram_message_id"
    t.text "text"
    t.integer "views"
    t.integer "forwards"
    t.integer "replies"
    t.datetime "posted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id", "posted_at"], name: "index_posts_on_channel_and_posted_at"
    t.index ["channel_id", "views"], name: "index_posts_on_channel_and_views"
    t.index ["channel_id"], name: "index_posts_on_channel_id"
    t.index ["posted_at", "views"], name: "index_posts_on_posted_at_and_views"
    t.index ["posted_at"], name: "index_posts_on_posted_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "collection_channels", "channels"
  add_foreign_key "collection_channels", "collections"
  add_foreign_key "collections", "users"
  add_foreign_key "posts", "channels"
end
