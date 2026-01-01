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

ActiveRecord::Schema[8.1].define(version: 2025_01_01_000009) do
  create_table "battles", force: :cascade do |t|
    t.integer "challenger_id", null: false
    t.datetime "created_at", null: false
    t.integer "opponent_id", null: false
    t.integer "points_gained", default: 0
    t.integer "points_lost", default: 0
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.integer "winner_id"
    t.index ["challenger_id", "opponent_id"], name: "index_battles_on_challenger_id_and_opponent_id"
    t.index ["challenger_id"], name: "index_battles_on_challenger_id"
    t.index ["opponent_id"], name: "index_battles_on_opponent_id"
    t.index ["status"], name: "index_battles_on_status"
    t.index ["winner_id"], name: "index_battles_on_winner_id"
  end

  create_table "completed_exercises", force: :cascade do |t|
    t.date "completed_at", null: false
    t.datetime "created_at", null: false
    t.integer "exercise_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["exercise_id"], name: "index_completed_exercises_on_exercise_id"
    t.index ["user_id", "exercise_id", "completed_at"], name: "idx_on_user_id_exercise_id_completed_at_69dff988ac"
    t.index ["user_id"], name: "index_completed_exercises_on_user_id"
  end

  create_table "day_exercises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "day_id", null: false
    t.integer "exercise_id", null: false
    t.datetime "updated_at", null: false
    t.index ["day_id", "exercise_id"], name: "index_day_exercises_on_day_id_and_exercise_id", unique: true
    t.index ["day_id"], name: "index_day_exercises_on_day_id"
    t.index ["exercise_id"], name: "index_day_exercises_on_exercise_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "equipment"
    t.text "instructions"
    t.string "muscle_group"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["muscle_group"], name: "index_exercises_on_muscle_group"
    t.index ["name"], name: "index_exercises_on_name"
  end

  create_table "friends", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "friend_id", null: false
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["friend_id"], name: "index_friends_on_friend_id"
    t.index ["user_id", "friend_id"], name: "index_friends_on_user_id_and_friend_id", unique: true
    t.index ["user_id"], name: "index_friends_on_user_id"
  end

  create_table "training_days", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "day_name", null: false
    t.integer "day_order", null: false
    t.integer "split_id", null: false
    t.datetime "updated_at", null: false
    t.index ["split_id", "day_order"], name: "index_training_days_on_split_id_and_day_order", unique: true
    t.index ["split_id"], name: "index_training_days_on_split_id"
  end

  create_table "training_splits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_splits", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "split_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["split_id"], name: "index_user_splits_on_split_id"
    t.index ["user_id", "split_id"], name: "index_user_splits_on_user_id_and_split_id", unique: true
    t.index ["user_id"], name: "index_user_splits_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.decimal "bodyweight", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.boolean "is_admin", default: false
    t.string "password_digest", null: false
    t.integer "total_points", default: 0
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "battles", "users", column: "challenger_id"
  add_foreign_key "battles", "users", column: "opponent_id"
  add_foreign_key "battles", "users", column: "winner_id"
  add_foreign_key "completed_exercises", "exercises"
  add_foreign_key "completed_exercises", "users"
  add_foreign_key "day_exercises", "exercises"
  add_foreign_key "day_exercises", "training_days", column: "day_id"
  add_foreign_key "friends", "users"
  add_foreign_key "friends", "users", column: "friend_id"
  add_foreign_key "training_days", "training_splits", column: "split_id"
  add_foreign_key "user_splits", "training_splits", column: "split_id"
  add_foreign_key "user_splits", "users"
end
