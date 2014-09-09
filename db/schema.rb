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

ActiveRecord::Schema.define(version: 20140829222125) do

  create_table "grants", force: true do |t|
    t.integer  "team_id",       null: false
    t.integer  "resource_id",   null: false
    t.string   "resource_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grants", ["team_id", "resource_id", "resource_type"], name: "index_grants_on_team_id_and_resource_id_and_resource_type", unique: true

  create_table "memberships", force: true do |t|
    t.integer  "team_id",    null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["team_id", "user_id"], name: "index_memberships_on_team_id_and_user_id", unique: true

  create_table "service_plans", force: true do |t|
    t.integer  "service_id",                  null: false
    t.string   "name",                        null: false
    t.string   "description",                 null: false
    t.boolean  "free",         default: true
    t.string   "bullets"
    t.string   "display_name"
    t.boolean  "public",       default: true, null: false
    t.integer  "creator_id",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "service_plans", ["public"], name: "index_service_plans_on_public"
  add_index "service_plans", ["service_id", "name"], name: "index_service_plans_on_service_id_and_name", unique: true

  create_table "services", force: true do |t|
    t.string   "name",                                  null: false
    t.string   "description",                           null: false
    t.boolean  "bindable",              default: true,  null: false
    t.string   "tags"
    t.boolean  "requires_syslog_drain", default: false
    t.string   "display_name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "long_description"
    t.string   "provider"
    t.string   "documentation_url"
    t.string   "support_url"
    t.string   "source_url"
    t.integer  "license",                               null: false
    t.boolean  "public",                default: true,  null: false
    t.integer  "creator_id",                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "services", ["name"], name: "index_services_on_name", unique: true
  add_index "services", ["public"], name: "index_services_on_public"

  create_table "teams", force: true do |t|
    t.string   "name",         null: false
    t.string   "description",  null: false
    t.integer  "access_level", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["name"], name: "index_teams_on_name", unique: true

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name",                            null: false
    t.string   "last_name",                             null: false
    t.boolean  "public",                 default: true, null: false
    t.integer  "role",                                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
