# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 6) do

  create_table "commits", :force => true do |t|
    t.integer  "revision"
    t.string   "user"
    t.datetime "date"
    t.text     "files"
    t.text     "comments"
    t.integer  "release_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.text     "changes_text"
    t.text     "testing_text"
    t.boolean  "processed"
  end

  create_table "releases", :force => true do |t|
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "name"
    t.text     "comments"
    t.text     "changes_text"
    t.text     "testing_text"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
