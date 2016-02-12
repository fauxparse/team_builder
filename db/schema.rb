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

ActiveRecord::Schema.define(version: 20160212013725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allocations", force: :cascade do |t|
    t.integer  "occurrence_id"
    t.integer  "role_id"
    t.integer  "minimum",       default: 0
    t.integer  "maximum"
    t.integer  "position"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["occurrence_id", "role_id"], name: "index_allocations_on_occurrence_id_and_role_id", using: :btree
    t.index ["occurrence_id"], name: "index_allocations_on_occurrence_id", using: :btree
    t.index ["role_id"], name: "index_allocations_on_role_id", using: :btree
  end

  create_table "availabilities", force: :cascade do |t|
    t.integer  "occurrence_id"
    t.integer  "member_id"
    t.integer  "enthusiasm",    default: 2
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["member_id", "occurrence_id"], name: "index_availabilities_on_member_id_and_occurrence_id", unique: true, using: :btree
    t.index ["member_id"], name: "index_availabilities_on_member_id", using: :btree
    t.index ["occurrence_id", "member_id"], name: "index_availabilities_on_occurrence_id_and_member_id", unique: true, using: :btree
    t.index ["occurrence_id"], name: "index_availabilities_on_occurrence_id", using: :btree
  end

  create_table "event_recurrence_rules", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "repeat_type",   default: 0
    t.integer  "interval",      default: 1
    t.integer  "count"
    t.datetime "stops_at"
    t.integer  "weekdays",      default: [],              array: true
    t.integer  "monthly_weeks", default: [],              array: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["event_id"], name: "index_event_recurrence_rules_on_event_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "name"
    t.string   "slug"
    t.text     "description"
    t.datetime "starts_at"
    t.datetime "stops_at"
    t.string   "time_zone_name"
    t.integer  "duration"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["team_id", "slug"], name: "index_events_on_team_id_and_slug", unique: true, using: :btree
    t.index ["team_id"], name: "index_events_on_team_id", using: :btree
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "members", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.string   "display_name"
    t.boolean  "admin",        default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["team_id", "user_id"], name: "index_members_on_team_id_and_user_id", using: :btree
    t.index ["team_id"], name: "index_members_on_team_id", using: :btree
    t.index ["user_id"], name: "index_members_on_user_id", using: :btree
  end

  create_table "occurrences", force: :cascade do |t|
    t.integer  "event_id"
    t.datetime "starts_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "starts_at"], name: "index_occurrences_on_event_id_and_starts_at", unique: true, using: :btree
    t.index ["event_id"], name: "index_occurrences_on_event_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "name"
    t.string   "plural"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_roles_on_team_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_teams_on_slug", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "allocations", "occurrences", on_delete: :cascade
  add_foreign_key "allocations", "roles", on_delete: :cascade
  add_foreign_key "availabilities", "members"
  add_foreign_key "availabilities", "occurrences"
  add_foreign_key "event_recurrence_rules", "events", on_delete: :cascade
  add_foreign_key "events", "teams", on_delete: :cascade
  add_foreign_key "identities", "users", on_delete: :cascade
  add_foreign_key "members", "teams", on_delete: :cascade
  add_foreign_key "members", "users", on_delete: :cascade
  add_foreign_key "occurrences", "events"
  add_foreign_key "roles", "teams"
end
