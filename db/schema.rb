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

ActiveRecord::Schema.define(version: 20150617080237) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.text     "comment",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["item_id"], name: "index_comments_on_item_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.integer  "topic_id"
    t.string   "email",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["topic_id", "email"], name: "index_invitations_on_topic_id_and_email", unique: true, using: :btree
  add_index "invitations", ["topic_id"], name: "index_invitations_on_topic_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.integer  "list_id"
    t.string   "name",       null: false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["list_id"], name: "index_items_on_list_id", using: :btree

  create_table "lists", force: :cascade do |t|
    t.integer  "topic_id"
    t.string   "name",       null: false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["topic_id"], name: "index_lists_on_topic_id", using: :btree

  create_table "shares", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shares", ["topic_id"], name: "index_shares_on_topic_id", using: :btree
  add_index "shares", ["user_id", "topic_id"], name: "index_shares_on_user_id_and_topic_id", unique: true, using: :btree
  add_index "shares", ["user_id"], name: "index_shares_on_user_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.string   "name",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
