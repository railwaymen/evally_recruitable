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

ActiveRecord::Schema.define(version: 2021_04_27_133431) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "changes", force: :cascade do |t|
    t.string "context", null: false
    t.string "from"
    t.string "to", null: false
    t.jsonb "details", default: {}
    t.string "changeable_type", null: false
    t.bigint "changeable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_token"
    t.index ["changeable_type", "changeable_id"], name: "index_changes_on_changeable_type_and_changeable_id"
    t.index ["user_token"], name: "index_changes_on_user_token"
  end

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
    t.datetime "task_sent_at"
    t.datetime "call_scheduled_at"
    t.datetime "interview_scheduled_at"
    t.text "rejection_reason"
    t.string "message_id"
    t.jsonb "social_links", default: [], null: false
    t.string "public_recruit_id", null: false
    t.text "incomplete_details"
    t.string "salary"
    t.string "availability"
    t.date "available_since"
    t.string "contract_type"
    t.string "work_type"
    t.string "location"
    t.text "message"
    t.string "evaluator_token"
    t.index ["public_recruit_id"], name: "index_recruit_documents_on_public_recruit_id"
  end

  create_table "recruitment_candidates", force: :cascade do |t|
    t.bigint "recruitment_id", null: false
    t.bigint "recruit_document_id", null: false
    t.string "stage", null: false
    t.integer "position", default: 0, null: false
    t.integer "priority", default: 0, null: false
    t.index ["recruit_document_id", "recruitment_id"], name: "index_recruit_document_recruitment_on_ids"
    t.index ["recruitment_id", "recruit_document_id"], name: "index_recruitment_recruit_document_on_ids"
  end

  create_table "recruitment_participants", force: :cascade do |t|
    t.bigint "recruitment_id", null: false
    t.bigint "user_id", null: false
    t.index ["recruitment_id", "user_id"], name: "index_recruitment_participants_on_recruitment_id_and_user_id"
    t.index ["user_id", "recruitment_id"], name: "index_recruitment_participants_on_user_id_and_recruitment_id"
  end

  create_table "recruitments", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.jsonb "stages", default: [], null: false
    t.string "status", default: "draft", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "role", null: false
    t.string "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email_token", null: false
    t.text "signature"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["email_token"], name: "index_users_on_email_token"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
