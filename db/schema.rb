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

ActiveRecord::Schema.define(version: 2020_04_28_053933) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "county"
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "passwordless_sessions", force: :cascade do |t|
    t.string "authenticatable_type"
    t.bigint "authenticatable_id"
    t.datetime "timeout_at", null: false
    t.datetime "expires_at", null: false
    t.datetime "claimed_at"
    t.text "user_agent", null: false
    t.string "remote_addr", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authenticatable_type", "authenticatable_id"], name: "authenticatable"
  end

  create_table "respondents", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.bigint "survey_invitation_id", null: false
    t.bigint "agency_id", null: false
    t.index ["agency_id"], name: "index_respondents_on_agency_id"
    t.index ["survey_invitation_id"], name: "index_respondents_on_survey_invitation_id"
  end

  create_table "survey_invitations", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.bigint "agency_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
    t.datetime "used_at"
    t.index ["agency_id"], name: "index_survey_invitations_on_agency_id"
    t.index ["email"], name: "index_survey_invitations_on_email", unique: true
    t.index ["phone"], name: "index_survey_invitations_on_phone", unique: true
    t.index ["token"], name: "index_survey_invitations_on_token", unique: true
  end

  create_table "surveys", force: :cascade do |t|
    t.jsonb "data"
    t.bigint "agency_id", null: false
    t.bigint "respondent_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["agency_id"], name: "index_surveys_on_agency_id"
    t.index ["respondent_id"], name: "index_surveys_on_respondent_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.bigint "agency_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["agency_id"], name: "index_users_on_agency_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "respondents", "agencies"
  add_foreign_key "respondents", "survey_invitations"
  add_foreign_key "survey_invitations", "agencies"
  add_foreign_key "surveys", "agencies"
  add_foreign_key "surveys", "respondents"
end
