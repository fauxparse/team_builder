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

ActiveRecord::Schema.define(version: 20160310011855) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allocations", force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "minimum",    default: 0
    t.integer  "maximum"
    t.integer  "position"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "event_id"
  end

  add_index "allocations", ["event_id", "role_id"], name: "index_allocations_on_event_id_and_role_id", using: :btree
  add_index "allocations", ["event_id"], name: "index_allocations_on_event_id", using: :btree
  add_index "allocations", ["role_id"], name: "index_allocations_on_role_id", using: :btree

  create_table "assignments", force: :cascade do |t|
    t.integer  "occurrence_id"
    t.integer  "allocation_id"
    t.integer  "member_id"
    t.integer  "position"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "assignments", ["allocation_id"], name: "index_assignments_on_allocation_id", using: :btree
  add_index "assignments", ["member_id", "occurrence_id"], name: "assignments_by_member", unique: true, using: :btree
  add_index "assignments", ["member_id"], name: "index_assignments_on_member_id", using: :btree
  add_index "assignments", ["occurrence_id", "allocation_id", "member_id"], name: "assignments_by_ids", unique: true, using: :btree
  add_index "assignments", ["occurrence_id"], name: "index_assignments_on_occurrence_id", using: :btree

  create_table "availabilities", force: :cascade do |t|
    t.integer  "occurrence_id"
    t.integer  "member_id"
    t.integer  "enthusiasm",    default: 2
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "availabilities", ["member_id", "occurrence_id"], name: "index_availabilities_on_member_id_and_occurrence_id", unique: true, using: :btree
  add_index "availabilities", ["member_id"], name: "index_availabilities_on_member_id", using: :btree
  add_index "availabilities", ["occurrence_id", "member_id"], name: "index_availabilities_on_occurrence_id_and_member_id", unique: true, using: :btree
  add_index "availabilities", ["occurrence_id"], name: "index_availabilities_on_occurrence_id", using: :btree

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
  end

  add_index "event_recurrence_rules", ["event_id"], name: "index_event_recurrence_rules_on_event_id", using: :btree

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
  end

  add_index "events", ["team_id", "slug"], name: "index_events_on_team_id_and_slug", unique: true, using: :btree
  add_index "events", ["team_id"], name: "index_events_on_team_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "invitations", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "sponsor_id"
    t.string   "code",       limit: 40
    t.integer  "status",                default: 0
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "invitations", ["code"], name: "index_invitations_on_code", unique: true, using: :btree
  add_index "invitations", ["member_id"], name: "index_invitations_on_member_id", using: :btree
  add_index "invitations", ["sponsor_id"], name: "index_invitations_on_sponsor_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "user_id"
    t.string   "display_name"
    t.boolean  "admin",        default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "email"
  end

  add_index "members", ["team_id", "user_id"], name: "index_members_on_team_id_and_user_id", using: :btree
  add_index "members", ["team_id"], name: "index_members_on_team_id", using: :btree
  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "occurrences", force: :cascade do |t|
    t.integer  "event_id"
    t.datetime "starts_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "occurrences", ["event_id", "starts_at"], name: "index_occurrences_on_event_id_and_starts_at", unique: true, using: :btree
  add_index "occurrences", ["event_id"], name: "index_occurrences_on_event_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "name"
    t.string   "plural"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "roles", ["team_id"], name: "index_roles_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "teams", ["slug"], name: "index_teams_on_slug", unique: true, using: :btree

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
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "allocations", "events", on_delete: :cascade
  add_foreign_key "allocations", "roles", on_delete: :cascade
  add_foreign_key "assignments", "allocations", on_delete: :cascade
  add_foreign_key "assignments", "members", on_delete: :cascade
  add_foreign_key "assignments", "occurrences", on_delete: :cascade
  add_foreign_key "availabilities", "members"
  add_foreign_key "availabilities", "occurrences"
  add_foreign_key "event_recurrence_rules", "events", on_delete: :cascade
  add_foreign_key "events", "teams", on_delete: :cascade
  add_foreign_key "identities", "users", on_delete: :cascade
  add_foreign_key "invitations", "members"
  add_foreign_key "invitations", "members", column: "sponsor_id", on_delete: :cascade
  add_foreign_key "members", "teams", on_delete: :cascade
  add_foreign_key "members", "users", on_delete: :cascade
  add_foreign_key "occurrences", "events"
  add_foreign_key "roles", "teams"
end
