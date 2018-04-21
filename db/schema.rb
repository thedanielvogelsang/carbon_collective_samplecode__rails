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

ActiveRecord::Schema.define(version: 20180421061846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "state"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "county"
    t.bigint "zipcode_id"
    t.bigint "neighborhood_id"
    t.string "neighborhood_name"
    t.index ["neighborhood_id"], name: "index_addresses_on_neighborhood_id"
    t.index ["zipcode_id"], name: "index_addresses_on_zipcode_id"
  end

  create_table "admins", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_admins_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.decimal "total_energy_saved"
    t.decimal "avg_daily_energy_consumed_per_capita"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "avg_total_energy_saved_per_user"
    t.decimal "avg_daily_energy_consumed_per_user"
    t.index ["region_id"], name: "index_cities_on_region_id"
  end

  create_table "city_snapshots", force: :cascade do |t|
    t.bigint "city_id"
    t.decimal "total_energy_saved"
    t.decimal "average_daily_energy_consumption_per_user"
    t.decimal "average_total_energy_saved_per_user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_city_snapshots_on_city_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.decimal "total_energy_saved"
    t.decimal "avg_daily_energy_consumed_per_capita"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "avg_total_energy_saved_per_user"
    t.decimal "avg_daily_energy_consumed_per_user"
  end

  create_table "country_snapshots", force: :cascade do |t|
    t.bigint "country_id"
    t.decimal "total_energy_saved"
    t.decimal "average_daily_energy_consumption_per_user"
    t.decimal "average_total_energy_saved_per_user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_country_snapshots_on_country_id"
  end

  create_table "days", force: :cascade do |t|
    t.string "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "electric_bills", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.float "total_kwhs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "price"
    t.bigint "house_id"
    t.float "electricity_saved"
    t.index ["house_id"], name: "index_electric_bills_on_house_id"
  end

  create_table "friendships", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_user_id"
    t.index ["friend_user_id", "user_id"], name: "index_friendships_on_friend_user_id_and_user_id", unique: true
    t.index ["user_id", "friend_user_id"], name: "index_friendships_on_user_id_and_friend_user_id", unique: true
  end

  create_table "globals", force: :cascade do |t|
    t.decimal "total_energy_saved"
    t.decimal "total_water_saved"
    t.decimal "total_carbon_saved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "admin_id"
    t.index ["admin_id"], name: "index_groups_on_admin_id"
  end

  create_table "household_snapshots", force: :cascade do |t|
    t.bigint "house_id"
    t.decimal "average_daily_energy_consumption_per_resident"
    t.decimal "average_total_energy_saved_per_resident"
    t.decimal "total_energy_saved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_household_snapshots_on_house_id"
  end

  create_table "houses", force: :cascade do |t|
    t.float "total_sq_ft"
    t.integer "no_residents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "address_id"
    t.index ["address_id"], name: "index_houses_on_address_id"
  end

  create_table "neighborhood_snapshots", force: :cascade do |t|
    t.bigint "neighborhood_id"
    t.decimal "average_daily_energy_consumption_per_user"
    t.decimal "average_total_energy_saved_per_user"
    t.decimal "total_energy_saved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["neighborhood_id"], name: "index_neighborhood_snapshots_on_neighborhood_id"
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string "name"
    t.decimal "total_energy_saved"
    t.decimal "avg_daily_energy_consumed_per_capita"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "avg_total_energy_saved_per_user"
    t.decimal "avg_daily_energy_consumed_per_user"
    t.index ["city_id"], name: "index_neighborhoods_on_city_id"
  end

  create_table "region_snapshots", force: :cascade do |t|
    t.bigint "region_id"
    t.decimal "total_energy_saved"
    t.decimal "average_daily_energy_consumption_per_user"
    t.decimal "average_total_energy_saved_per_user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_region_snapshots_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.decimal "total_energy_saved"
    t.decimal "avg_daily_energy_consumed_per_capita"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "avg_total_energy_saved_per_user"
    t.decimal "avg_daily_energy_consumed_per_user"
    t.index ["country_id"], name: "index_regions_on_country_id"
  end

  create_table "trips", force: :cascade do |t|
    t.string "trip_name"
    t.string "mode_of_transport"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "trip_type"
    t.datetime "stop"
    t.bigint "day_id"
    t.text "timestamps", default: [], array: true
    t.index ["day_id"], name: "index_trips_on_day_id"
    t.index ["user_id"], name: "index_trips_on_user_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "user_houses", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "house_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_user_houses_on_house_id"
    t.index ["user_id"], name: "index_user_houses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first"
    t.string "last"
    t.string "email"
    t.string "uid"
    t.string "token"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "admins", array: true
    t.string "location", array: true
    t.string "url"
    t.string "provider"
    t.decimal "total_kwhs_logged"
    t.decimal "total_days_logged"
    t.decimal "total_electricity_savings"
  end

  create_table "zipcodes", force: :cascade do |t|
    t.string "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "addresses", "neighborhoods"
  add_foreign_key "addresses", "zipcodes"
  add_foreign_key "admins", "users"
  add_foreign_key "cities", "regions"
  add_foreign_key "city_snapshots", "cities"
  add_foreign_key "country_snapshots", "countries"
  add_foreign_key "electric_bills", "houses"
  add_foreign_key "groups", "admins"
  add_foreign_key "household_snapshots", "houses"
  add_foreign_key "houses", "addresses"
  add_foreign_key "neighborhood_snapshots", "neighborhoods"
  add_foreign_key "neighborhoods", "cities"
  add_foreign_key "region_snapshots", "regions"
  add_foreign_key "regions", "countries"
  add_foreign_key "trips", "days"
  add_foreign_key "trips", "users"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
  add_foreign_key "user_houses", "houses"
  add_foreign_key "user_houses", "users"
end
