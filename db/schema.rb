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

ActiveRecord::Schema[7.1].define(version: 2023_11_14_134358) do
  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "district"
    t.string "complement"
    t.string "postal_code"
    t.string "city"
    t.string "state"
    t.integer "supervisor_id"
    t.integer "coordinator_id"
    t.integer "researcher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "student_id"
    t.index ["coordinator_id"], name: "index_addresses_on_coordinator_id"
    t.index ["researcher_id"], name: "index_addresses_on_researcher_id"
    t.index ["student_id"], name: "index_addresses_on_student_id"
    t.index ["supervisor_id"], name: "index_addresses_on_supervisor_id"
  end

  create_table "coordinators", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "academic_field"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_coordinators_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "ric_number"
    t.integer "project_type"
    t.string "institution"
    t.string "course"
    t.string "study_area"
    t.string "research_line"
    t.text "ods"
    t.string "project_title"
    t.text "project_summary"
    t.text "key_words"
    t.integer "project_status", default: 0
    t.text "annotation", default: ""
    t.date "feedback_date"
    t.integer "researcher_id", null: false
    t.integer "coordinator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coordinator_id"], name: "index_projects_on_coordinator_id"
    t.index ["researcher_id"], name: "index_projects_on_researcher_id"
  end

  create_table "researchers", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "academic_field"
    t.string "cv_link"
    t.string "orcid_id"
    t.string "academic_title"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_researchers_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "social_security_number"
    t.string "identity_card_number"
    t.date "birth_date"
    t.string "phone_number"
    t.string "email"
    t.string "academic_field"
    t.string "course"
    t.integer "semester"
    t.boolean "has_subject_dependencies"
    t.boolean "is_regular_student"
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_students_on_project_id"
  end

  create_table "supervisors", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_supervisors_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "coordinators"
  add_foreign_key "addresses", "researchers"
  add_foreign_key "addresses", "students"
  add_foreign_key "addresses", "supervisors"
  add_foreign_key "coordinators", "users"
  add_foreign_key "projects", "coordinators"
  add_foreign_key "projects", "researchers"
  add_foreign_key "researchers", "users"
  add_foreign_key "students", "projects"
  add_foreign_key "supervisors", "users"
end
