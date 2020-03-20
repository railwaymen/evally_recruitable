# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_20_210556) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "recruit_documents", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "gender"
    t.string "email", null: false
    t.string "phone"
    t.string "status", default: "received", null: false
    t.string "position", null: false
    t.string "group", default: "Unassigned", null: false
    t.boolean "accept_current_processing", default: true, null: false
    t.boolean "accept_future_processing", null: false
    t.string "source"
    t.datetime "received_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
