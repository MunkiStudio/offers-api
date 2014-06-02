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

ActiveRecord::Schema.define(version: 20140530040721) do

  create_table "api_keys", force: true do |t|
    t.string   "access_token"
    t.datetime "expires_at"
    t.boolean  "active"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "categories_offers", force: true do |t|
    t.integer "category_id", null: false
    t.integer "offer_id",    null: false
  end

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["offer_id"], name: "index_comments_on_offer_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "groups", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["user_id"], name: "index_groups_on_user_id"

  create_table "likes", force: true do |t|
    t.integer  "user_id"
    t.integer  "offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["offer_id"], name: "index_likes_on_offer_id"
  add_index "likes", ["user_id"], name: "index_likes_on_user_id"

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id"
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id"

  create_table "notifications", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "verb"
    t.boolean  "readed",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["recipient_id"], name: "index_notifications_on_recipient_id"
  add_index "notifications", ["sender_id"], name: "index_notifications_on_sender_id"

  create_table "offers", force: true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "access_public",      default: true
  end

  add_index "offers", ["user_id"], name: "index_offers_on_user_id"

  create_table "shares", force: true do |t|
    t.integer  "offer_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shares", ["group_id"], name: "index_shares_on_group_id"
  add_index "shares", ["offer_id"], name: "index_shares_on_offer_id"

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.integer  "age"
    t.string   "password"
    t.string   "email"
    t.text     "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "localization"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["id"], name: "index_users_on_id", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
