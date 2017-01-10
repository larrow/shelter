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

ActiveRecord::Schema.define(version: 20170110173143) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "image_tags", force: :cascade do |t|
    t.string   "name"
    t.string   "digest"
    t.integer  "repository_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "members", force: :cascade do |t|
    t.integer  "namespace_id"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "access_level"
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "namespaces", force: :cascade do |t|
    t.string   "name"
    t.integer  "creator_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "default_publicity", default: true
    t.index ["creator_id"], name: "index_namespaces_on_creator_id", using: :btree
    t.index ["name"], name: "index_namespaces_on_name", using: :btree
  end

  create_table "registry_events", force: :cascade do |t|
    t.string   "original_id"
    t.string   "action"
    t.string   "repository"
    t.string   "actor"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "digest"
    t.string   "tag_name"
    t.index ["original_id"], name: "index_registry_events_on_original_id", unique: true, using: :btree
  end

  create_table "repositories", force: :cascade do |t|
    t.string   "name"
    t.integer  "pull_count"
    t.integer  "namespace_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.boolean  "is_public"
    t.text     "description"
    t.text     "description_html"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_repositories_on_deleted_at", using: :btree
    t.index ["name"], name: "index_repositories_on_name", using: :btree
    t.index ["namespace_id"], name: "index_repositories_on_namespace_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "username"
    t.boolean  "admin",                  default: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "members", "users"
  add_foreign_key "namespaces", "users", column: "creator_id"
  add_foreign_key "repositories", "namespaces"
end
