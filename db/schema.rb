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

ActiveRecord::Schema.define(version: 20151211022210) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chats", force: :cascade do |t|
    t.text     "message"
    t.integer  "user_id"
    t.integer  "room_id"
    t.datetime "deleted_at"
    t.datetime "created_at",    null: false
    t.integer  "media_type"
    t.text     "image_content"
    t.text     "video_content"
  end

  add_index "chats", ["created_at"], name: "index_chats_on_created_at", using: :btree
  add_index "chats", ["deleted_at"], name: "index_chats_on_deleted_at", using: :btree
  add_index "chats", ["media_type"], name: "index_chats_on_media_type", using: :btree
  add_index "chats", ["room_id"], name: "index_chats_on_room_id", using: :btree
  add_index "chats", ["user_id"], name: "index_chats_on_user_id", using: :btree

  create_table "rooms", force: :cascade do |t|
    t.text     "name"
    t.text     "description"
    t.integer  "privacy"
    t.integer  "user_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "slug"
    t.text     "photo"
    t.integer  "tenants_count", default: 0,     null: false
    t.integer  "chats_count",   default: 0,     null: false
    t.boolean  "nsfw",          default: false, null: false
  end

  add_index "rooms", ["nsfw"], name: "index_rooms_on_nsfw", using: :btree
  add_index "rooms", ["slug"], name: "index_rooms_on_slug", unique: true, using: :btree
  add_index "rooms", ["user_id"], name: "index_rooms_on_user_id", using: :btree

  create_table "tenants", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "room_id"
    t.integer  "last_chat"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "active",     default: true,  null: false
    t.boolean  "banned",     default: false, null: false
    t.boolean  "moderator",  default: false, null: false
  end

  add_index "tenants", ["active"], name: "index_tenants_on_active", using: :btree
  add_index "tenants", ["banned"], name: "index_tenants_on_banned", using: :btree
  add_index "tenants", ["last_chat"], name: "index_tenants_on_last_chat", using: :btree
  add_index "tenants", ["moderator"], name: "index_tenants_on_moderator", using: :btree
  add_index "tenants", ["room_id"], name: "index_tenants_on_room_id", using: :btree
  add_index "tenants", ["user_id", "room_id"], name: "index_tenants_on_user_id_and_room_id", unique: true, using: :btree
  add_index "tenants", ["user_id"], name: "index_tenants_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.text     "username"
    t.text     "email"
    t.integer  "admin"
    t.text     "password_digest"
    t.text     "remember_digest"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "guest",           default: true,  null: false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "username_set",    default: false, null: false
    t.text     "photo"
    t.text     "name"
    t.text     "bio"
    t.boolean  "online",          default: false, null: false
    t.datetime "last_call"
    t.text     "referral"
    t.integer  "sessions_count",  default: 0,     null: false
    t.text     "language"
    t.datetime "banned_at"
    t.text     "ip_address"
  end

  add_index "users", ["guest"], name: "index_users_on_guest", using: :btree
  add_index "users", ["language"], name: "index_users_on_language", using: :btree
  add_index "users", ["online"], name: "index_users_on_online", using: :btree
  add_index "users", ["referral"], name: "index_users_on_referral", using: :btree

end
