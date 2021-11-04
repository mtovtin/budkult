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

ActiveRecord::Schema.define(version: 2021_08_05_081030) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "plugins_attacks", force: :cascade do |t|
    t.string "path"
    t.string "browser_key"
    t.bigint "site_id"
    t.datetime "created_at"
    t.index ["browser_key"], name: "index_plugins_attacks_on_browser_key"
    t.index ["path"], name: "index_plugins_attacks_on_path"
    t.index ["site_id"], name: "index_plugins_attacks_on_site_id"
  end

  create_table "plugins_contact_forms", id: :serial, force: :cascade do |t|
    t.integer "site_id"
    t.integer "count"
    t.integer "parent_id"
    t.string "name"
    t.string "slug"
    t.text "description"
    t.text "value"
    t.text "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rdauzh_categorizations", id: :serial, force: :cascade do |t|
    t.integer "doc_id"
    t.integer "doc_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["doc_id", "doc_category_id"], name: "index_rdauzh_categorizations_on_doc_id_and_doc_category_id"
  end

  create_table "rdauzh_comments", id: :serial, force: :cascade do |t|
    t.string "author"
    t.string "author_email"
    t.string "author_url"
    t.string "author_IP"
    t.text "content"
    t.string "approved", default: "pending"
    t.string "agent"
    t.string "typee"
    t.integer "comment_parent"
    t.integer "post_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved"], name: "index_rdauzh_comments_on_approved"
    t.index ["comment_parent"], name: "index_rdauzh_comments_on_comment_parent"
    t.index ["post_id"], name: "index_rdauzh_comments_on_post_id"
    t.index ["user_id"], name: "index_rdauzh_comments_on_user_id"
  end

  create_table "rdauzh_custom_fields", id: :serial, force: :cascade do |t|
    t.string "object_class"
    t.string "name"
    t.string "slug"
    t.integer "objectid"
    t.integer "parent_id"
    t.integer "field_order"
    t.integer "count", default: 0
    t.boolean "is_repeat", default: false
    t.text "description"
    t.string "status"
    t.index ["object_class"], name: "index_rdauzh_custom_fields_on_object_class"
    t.index ["objectid"], name: "index_rdauzh_custom_fields_on_objectid"
    t.index ["parent_id"], name: "index_rdauzh_custom_fields_on_parent_id"
    t.index ["slug"], name: "index_rdauzh_custom_fields_on_slug"
  end

  create_table "rdauzh_custom_fields_relationships", id: :serial, force: :cascade do |t|
    t.integer "objectid"
    t.integer "custom_field_id"
    t.integer "term_order"
    t.string "object_class"
    t.text "value"
    t.string "custom_field_slug"
    t.integer "group_number", default: 0
    t.index ["custom_field_id"], name: "index_rdauzh_custom_fields_relationships_on_custom_field_id"
    t.index ["custom_field_slug"], name: "index_rdauzh_custom_fields_relationships_on_custom_field_slug"
    t.index ["object_class"], name: "index_rdauzh_custom_fields_relationships_on_object_class"
    t.index ["objectid"], name: "index_rdauzh_custom_fields_relationships_on_objectid"
  end

  create_table "rdauzh_doc_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "doc_type", default: "nope"
  end

  create_table "rdauzh_doc_tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
  end

  create_table "rdauzh_docs", id: :serial, force: :cascade do |t|
    t.integer "site_id"
    t.string "title"
    t.string "slug"
    t.text "content"
    t.string "rada_docs_url"
    t.string "status", default: "published"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "special_type"
    t.integer "doc_type"
    t.string "mce_session_number"
    t.string "mce_forum_number"
    t.string "mce_text"
    t.date "mce_date"
    t.string "mce_doc_number"
    t.integer "user_id"
    t.json "options", default: {}
    t.integer "counter"
    t.integer "doc_index"
    t.string "full_index"
    t.string "source_folder"
    t.datetime "receipt_date"
    t.string "source"
    t.string "branch"
    t.string "ground"
    t.string "keywords"
    t.string "file_type"
    t.string "kind"
    t.integer "file_counter"
    t.string "file_name"
    t.string "doc_stamp"
    t.index ["branch"], name: "index_rdauzh_docs_on_branch", where: "(branch IS NOT NULL)"
    t.index ["counter"], name: "index_rdauzh_docs_on_counter", unique: true, where: "(counter IS NOT NULL)"
    t.index ["doc_index"], name: "index_rdauzh_docs_on_doc_index", where: "(doc_index IS NOT NULL)"
    t.index ["kind"], name: "index_rdauzh_docs_on_kind", where: "(kind IS NOT NULL)"
    t.index ["mce_doc_number"], name: "index_rdauzh_docs_on_mce_doc_number", where: "(mce_doc_number IS NOT NULL)"
    t.index ["site_id"], name: "index_rdauzh_docs_on_site_id"
    t.index ["slug"], name: "index_rdauzh_docs_on_slug"
    t.index ["source"], name: "index_rdauzh_docs_on_source", where: "(source IS NOT NULL)"
    t.index ["status"], name: "index_rdauzh_docs_on_status"
  end

  create_table "rdauzh_media", id: :serial, force: :cascade do |t|
    t.integer "site_id"
    t.string "name"
    t.boolean "is_folder", default: false
    t.string "folder_path"
    t.string "file_size"
    t.string "dimension", default: ""
    t.string "file_type"
    t.string "url"
    t.string "thumb"
    t.boolean "is_public", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["folder_path"], name: "index_rdauzh_media_on_folder_path"
    t.index ["is_folder"], name: "index_rdauzh_media_on_is_folder"
    t.index ["name"], name: "index_rdauzh_media_on_name"
    t.index ["site_id"], name: "index_rdauzh_media_on_site_id"
  end

  create_table "rdauzh_metas", id: :serial, force: :cascade do |t|
    t.string "key"
    t.text "value"
    t.integer "objectid"
    t.string "object_class"
    t.index ["key"], name: "index_rdauzh_metas_on_key"
    t.index ["object_class"], name: "index_rdauzh_metas_on_object_class"
    t.index ["objectid"], name: "index_rdauzh_metas_on_objectid"
  end

  create_table "rdauzh_note_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.boolean "is_enabled", default: true
  end

  create_table "rdauzh_note_cattings", id: :serial, force: :cascade do |t|
    t.integer "note_id"
    t.integer "note_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["note_id", "note_category_id"], name: "index_rdauzh_note_cattings_on_note_id_and_note_category_id"
  end

  create_table "rdauzh_note_taggings", id: :serial, force: :cascade do |t|
    t.integer "note_id"
    t.integer "note_tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["note_id", "note_tag_id"], name: "index_rdauzh_note_taggings_on_note_id_and_note_tag_id"
  end

  create_table "rdauzh_note_tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
  end

  create_table "rdauzh_notes", id: :serial, force: :cascade do |t|
    t.integer "site_id"
    t.string "title"
    t.string "slug"
    t.text "content"
    t.string "post_imported_thumb"
    t.string "status", default: "published"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "slider_images"
    t.json "options", default: {}
    t.integer "user_id"
    t.index ["site_id"], name: "index_rdauzh_notes_on_site_id"
    t.index ["slug"], name: "index_rdauzh_notes_on_slug"
    t.index ["status"], name: "index_rdauzh_notes_on_status"
  end

  create_table "rdauzh_petitions", id: :serial, force: :cascade do |t|
    t.integer "site_id"
    t.string "title"
    t.string "number"
    t.string "author"
    t.string "deadline"
    t.integer "votes_need", default: 0
    t.integer "real_votes", default: 0
    t.string "slug"
    t.text "content"
    t.text "voters"
    t.text "answer"
    t.string "status_answer", default: "default"
    t.string "status_archive", default: "default"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["site_id"], name: "index_rdauzh_petitions_on_site_id"
    t.index ["slug"], name: "index_rdauzh_petitions_on_slug"
  end

  create_table "rdauzh_posts", id: :serial, force: :cascade do |t|
    t.text "title"
    t.text "slug"
    t.text "content"
    t.text "content_filtered"
    t.string "status", default: "published"
    t.datetime "published_at"
    t.integer "post_parent"
    t.string "visibility", default: "public"
    t.text "visibility_value"
    t.string "post_class", default: "Post"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "post_order", default: 0
    t.integer "taxonomy_id"
    t.boolean "is_feature", default: false
    t.json "options", default: {}
    t.index ["post_class"], name: "index_rdauzh_posts_on_post_class"
    t.index ["post_parent"], name: "index_rdauzh_posts_on_post_parent"
    t.index ["slug"], name: "index_rdauzh_posts_on_slug"
    t.index ["status"], name: "index_rdauzh_posts_on_status"
    t.index ["user_id"], name: "index_rdauzh_posts_on_user_id"
  end

  create_table "rdauzh_request", id: :serial, force: :cascade do |t|
    t.integer "site_id"
    t.text "title"
    t.string "name"
    t.text "content"
    t.string "address"
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["site_id"], name: "index_rdauzh_request_on_site_id"
  end

  create_table "rdauzh_taggings", id: :serial, force: :cascade do |t|
    t.integer "doc_id"
    t.integer "doc_tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["doc_id", "doc_tag_id"], name: "index_rdauzh_taggings_on_doc_id_and_doc_tag_id"
  end

  create_table "rdauzh_term_relationships", id: :serial, force: :cascade do |t|
    t.integer "objectid"
    t.integer "term_order"
    t.integer "term_taxonomy_id"
    t.index ["objectid"], name: "index_rdauzh_term_relationships_on_objectid"
    t.index ["term_order"], name: "index_rdauzh_term_relationships_on_term_order"
    t.index ["term_taxonomy_id"], name: "index_rdauzh_term_relationships_on_term_taxonomy_id"
  end

  create_table "rdauzh_term_taxonomy", id: :serial, force: :cascade do |t|
    t.string "taxonomy"
    t.text "description"
    t.integer "parent_id"
    t.integer "count"
    t.text "name"
    t.string "slug"
    t.integer "term_group"
    t.integer "term_order"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["parent_id"], name: "index_rdauzh_term_taxonomy_on_parent_id"
    t.index ["slug"], name: "index_rdauzh_term_taxonomy_on_slug"
    t.index ["taxonomy"], name: "index_rdauzh_term_taxonomy_on_taxonomy"
    t.index ["term_order"], name: "index_rdauzh_term_taxonomy_on_term_order"
    t.index ["user_id"], name: "index_rdauzh_term_taxonomy_on_user_id"
  end

  create_table "rdauzh_users", id: :serial, force: :cascade do |t|
    t.string "username"
    t.string "role", default: "client"
    t.string "email"
    t.string "slug"
    t.string "password_digest"
    t.string "auth_token"
    t.string "password_reset_token"
    t.integer "parent_id"
    t.datetime "password_reset_sent_at"
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "site_id", default: -1
    t.string "confirm_email_token"
    t.datetime "confirm_email_sent_at"
    t.boolean "is_valid_email", default: true
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_rdauzh_users_on_email"
    t.index ["role"], name: "index_rdauzh_users_on_role"
    t.index ["site_id"], name: "index_rdauzh_users_on_site_id"
    t.index ["username"], name: "index_rdauzh_users_on_username"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
