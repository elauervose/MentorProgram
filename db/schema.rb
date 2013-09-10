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

ActiveRecord::Schema.define(version: 20130910155442) do

  create_table "answers", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "ask_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["ask_id"], name: "index_answers_on_ask_id"

  create_table "asks", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.boolean  "email_updates"
    t.boolean  "answered",      default: false
    t.string   "type"
  end

  create_table "asks_categories", force: true do |t|
    t.integer "ask_id"
    t.integer "category_id"
  end

  add_index "asks_categories", ["ask_id", "category_id"], name: "index_asks_categories_on_ask_id_and_category_id", unique: true

  create_table "asks_locations", force: true do |t|
    t.integer "ask_id"
    t.integer "location_id"
  end

  add_index "asks_locations", ["ask_id", "location_id"], name: "index_asks_locations_on_ask_id_and_location_id", unique: true

  create_table "asks_meetup_times", force: true do |t|
    t.integer "ask_id"
    t.integer "meetup_time_id"
  end

  add_index "asks_meetup_times", ["ask_id", "meetup_time_id"], name: "index_asks_meetup_times_on_ask_id_and_meetup_time_id", unique: true

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "official",   default: false
  end

  create_table "locations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meetup_times", force: true do |t|
    t.string   "day"
    t.string   "period"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
