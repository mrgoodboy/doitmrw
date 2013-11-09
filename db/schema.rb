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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131109002140) do

  create_table "categories", :force => true do |t|
    t.string "name"
    t.string "slug"
  end

  create_table "content", :force => true do |t|
    t.integer  "type_id"
    t.integer  "category_id"
    t.integer  "user_id"
    t.string   "text"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "flags"
    t.boolean  "new"
    t.string   "title"
  end

  add_index "content", ["new"], :name => "index_content_on_new"

  create_table "edges", :force => true do |t|
    t.integer "user_id"
    t.integer "content_id"
    t.float   "weight"
  end

  create_table "types", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
  end

end
