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

ActiveRecord::Schema[7.0].define(version: 920) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "published_at"
    t.boolean "deleted"
    t.datetime "deleted_at"
    t.string "title"
    t.string "content"
    t.string "content_plain"
    t.string "status"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted"], name: "index_entries_on_deleted"
    t.index ["deleted_at"], name: "index_entries_on_deleted_at"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "mentions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "person_id"
    t.uuid "entry_id"
    t.uuid "user_id"
    t.string "added_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_id"], name: "index_mentions_on_entry_id"
    t.index ["person_id"], name: "index_mentions_on_person_id"
    t.index ["user_id"], name: "index_mentions_on_user_id"
  end

  create_table "notes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "content"
    t.uuid "user_id", null: false
    t.string "notable_type", null: false
    t.uuid "notable_id", null: false
    t.boolean "deleted"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted"], name: "index_notes_on_deleted"
    t.index ["deleted_at"], name: "index_notes_on_deleted_at"
    t.index ["notable_type", "notable_id"], name: "index_notes_on_notable"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "nickname"
    t.string "gender"
    t.string "biography"
    t.string "notes"
    t.boolean "deleted"
    t.datetime "deleted_at"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted"], name: "index_people_on_deleted"
    t.index ["deleted_at"], name: "index_people_on_deleted_at"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "personalities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "person_id", null: false
    t.uuid "trait_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_personalities_on_person_id"
    t.index ["trait_id"], name: "index_personalities_on_trait_id"
  end

  create_table "pictures", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.string "title"
    t.uuid "entry_id", null: false
    t.uuid "user_id", null: false
    t.boolean "deleted"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted"], name: "index_pictures_on_deleted"
    t.index ["deleted_at"], name: "index_pictures_on_deleted_at"
    t.index ["entry_id"], name: "index_pictures_on_entry_id"
    t.index ["user_id"], name: "index_pictures_on_user_id"
  end

  create_table "quotes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "content"
    t.string "author"
    t.string "source"
    t.boolean "deleted"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted"], name: "index_quotes_on_deleted"
    t.index ["deleted_at"], name: "index_quotes_on_deleted_at"
  end

  create_table "traits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "word"
    t.integer "positivity"
    t.integer "importance"
    t.string "status"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "status"
    t.string "stay_signed_in_token"
    t.datetime "stay_signed_in_token_expires_at"
    t.boolean "deleted"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted"], name: "index_users_on_deleted"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["stay_signed_in_token"], name: "index_users_on_stay_signed_in_token"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "entries", "users"
  add_foreign_key "mentions", "entries"
  add_foreign_key "mentions", "people"
  add_foreign_key "mentions", "users"
  add_foreign_key "notes", "users"
  add_foreign_key "people", "users"
  add_foreign_key "personalities", "people"
  add_foreign_key "personalities", "traits"
  add_foreign_key "pictures", "entries"
  add_foreign_key "pictures", "users"
end
