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

ActiveRecord::Schema.define(version: 20170912110746) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acme_certs", force: :cascade do |t|
    t.bigint "route_id"
    t.string "email"
    t.text "private_key"
    t.string "status"
    t.string "auth_uri"
    t.string "token"
    t.string "filename"
    t.text "file_content"
    t.string "challenge_verify_status"
    t.string "auth_verify_status"
    t.text "error"
    t.text "private_pem"
    t.text "cert_pem"
    t.text "chain_pem"
    t.text "fullchain_pem"
    t.datetime "expires_at"
    t.datetime "issued_at"
    t.bigint "app_id"
    t.bigint "ssl_route_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_acme_certs_on_app_id"
    t.index ["route_id"], name: "index_acme_certs_on_route_id"
    t.index ["ssl_route_id"], name: "index_acme_certs_on_ssl_route_id"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "apps", force: :cascade do |t|
    t.string "f_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "backup_schemas", force: :cascade do |t|
    t.bigint "app_id"
    t.bigint "resource_id"
    t.integer "days"
    t.integer "hours"
    t.integer "retention"
    t.boolean "enabled"
    t.integer "backups_count"
    t.datetime "run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "backup_type", default: 0, null: false
    t.index ["app_id"], name: "index_backup_schemas_on_app_id"
    t.index ["resource_id"], name: "index_backup_schemas_on_resource_id"
  end

  create_table "backups", force: :cascade do |t|
    t.bigint "app_id"
    t.bigint "resource_id"
    t.bigint "backup_schema_id"
    t.string "file"
    t.integer "file_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "backup_type", default: 0, null: false
    t.index ["app_id"], name: "index_backups_on_app_id"
    t.index ["backup_schema_id"], name: "index_backups_on_backup_schema_id"
    t.index ["resource_id"], name: "index_backups_on_resource_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "resources", force: :cascade do |t|
    t.bigint "app_id"
    t.string "type"
    t.string "f_id"
    t.string "provider_id"
    t.string "provider_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_resources_on_app_id"
  end

  create_table "routes", force: :cascade do |t|
    t.bigint "app_id"
    t.string "f_id"
    t.string "route"
    t.string "service"
    t.boolean "sticky"
    t.boolean "leader"
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_routes_on_app_id"
  end

  add_foreign_key "acme_certs", "apps"
  add_foreign_key "acme_certs", "routes"
  add_foreign_key "acme_certs", "routes", column: "ssl_route_id"
  add_foreign_key "backup_schemas", "apps"
  add_foreign_key "backup_schemas", "resources"
  add_foreign_key "backups", "apps"
  add_foreign_key "backups", "backup_schemas"
  add_foreign_key "backups", "resources"
  add_foreign_key "resources", "apps"
  add_foreign_key "routes", "apps"
end
