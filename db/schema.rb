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

ActiveRecord::Schema.define(version: 20180713174611) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "analytic_entries", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.json "payload", null: false
    t.string "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ip"
  end

  create_table "contacts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "zipcode"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "campaign_id", null: false
  end

  create_table "expenditures", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "paid_to", null: false
    t.string "purpose", null: false
    t.string "address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "country", null: false
    t.datetime "date_paid", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.string "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "identifier", null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_kinds", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "from_whom", null: false
    t.string "description", null: false
    t.string "address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "country", null: false
    t.datetime "date_received", null: false
    t.integer "value_cents", default: 0, null: false
    t.string "value_currency", default: "USD", null: false
    t.string "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "phone_number"
  end

  create_table "liabilities", force: :cascade do |t|
    t.string "to_whom", null: false
    t.string "purpose", null: false
    t.string "address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "country", null: false
    t.datetime "date_incurred", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.string "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "subject", null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "campaign_id", null: false
  end

  create_table "receipts", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.datetime "date_received", null: false
    t.string "occupation", default: ""
    t.string "employer", default: ""
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.string "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "phone_number"
    t.string "receipt_type", default: "donation", null: false
    t.string "country"
  end

  create_table "reports", force: :cascade do |t|
    t.string "report_type", null: false
    t.datetime "beginning_date", null: false
    t.datetime "ending_date", null: false
    t.string "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "waiting", null: false
  end

  create_table "volunteers", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "phone_number"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "address"
    t.string "zipcode", null: false
    t.string "city"
    t.string "state"
    t.text "help_blurb"
    t.uuid "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "campaign_id", null: false
    t.index ["contact_id"], name: "index_volunteers_on_contact_id"
  end

  add_foreign_key "volunteers", "contacts"
end
