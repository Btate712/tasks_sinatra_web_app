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

ActiveRecord::Schema.define(version: 2019_04_28_112611) do

  create_table "notes", force: :cascade do |t|
    t.string "content"
    t.integer "task_id"
    t.integer "user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "short_description"
    t.string "long_description"
    t.integer "creator_id"
    t.integer "owner_id"
    t.date "due_date"
    t.boolean "completed"
  end

  create_table "users", force: :cascade do |t|
    t.string "password_digest"
    t.string "username"
    t.string "email"
    t.integer "manager_id"
    t.string "name"
  end

end
