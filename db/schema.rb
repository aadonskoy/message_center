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

ActiveRecord::Schema[7.0].define(version: 2023_07_15_162428) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "messages", force: :cascade do |t|
    t.text "text"
    t.string "phone_number", limit: 25
    t.integer "status", default: 0, null: false
    t.uuid "public_id", default: -> { "gen_random_uuid()" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_messages_on_created_at"
    t.index ["phone_number"], name: "index_messages_on_phone_number"
    t.index ["public_id"], name: "index_messages_on_public_id"
    t.index ["status", "public_id"], name: "index_messages_on_status_and_public_id"
    t.index ["status"], name: "index_messages_on_status"
  end

end
