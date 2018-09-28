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

ActiveRecord::Schema.define(version: 20180928043245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "address_line1"
    t.string "address_line2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.bigint "zipcode_id"
    t.bigint "neighborhood_id"
    t.bigint "city_id"
    t.bigint "county_id"
    t.index ["city_id"], name: "index_addresses_on_city_id"
    t.index ["county_id"], name: "index_addresses_on_county_id"
    t.index ["neighborhood_id"], name: "index_addresses_on_neighborhood_id"
    t.index ["zipcode_id"], name: "index_addresses_on_zipcode_id"
  end

  create_table "admins", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_admins_on_user_id"
  end

  create_table "carbon_rankings", force: :cascade do |t|
    t.string "area_type"
    t.bigint "area_id"
    t.integer "rank"
    t.boolean "arrow"
    t.index ["area_id", "area_type"], name: "index_carbon_rankings_on_area_id_and_area_type"
    t.index ["area_type", "area_id"], name: "index_carbon_rankings_on_area_type_and_area_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.decimal "total_electricity_saved", default: "0.0"
    t.decimal "total_gas_saved", default: "0.0"
    t.decimal "total_water_saved", default: "0.0"
    t.decimal "avg_daily_electricity_consumed_per_capita"
    t.decimal "avg_daily_gas_consumed_per_capita"
    t.decimal "avg_daily_water_consumed_per_capita"
    t.decimal "avg_total_electricity_saved_per_user", default: "0.0"
    t.decimal "avg_total_gas_saved_per_user", default: "0.0"
    t.decimal "avg_total_water_saved_per_user", default: "0.0"
    t.decimal "avg_daily_electricity_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_gas_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_water_consumed_per_user", default: "0.0"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_gas_consumed", default: "0.0"
    t.decimal "total_electricity_consumed", default: "0.0"
    t.decimal "total_water_consumed", default: "0.0"
    t.decimal "total_carbon_saved", default: "0.0"
    t.decimal "avg_daily_carbon_consumed_per_user", default: "0.0"
    t.decimal "total_carbon_consumed", default: "0.0"
    t.index ["name"], name: "index_cities_on_name", unique: true
    t.index ["region_id"], name: "index_cities_on_region_id"
    t.index ["total_electricity_consumed"], name: "index_cities_on_total_electricity_consumed"
    t.index ["total_electricity_saved"], name: "index_cities_on_total_electricity_saved"
    t.index ["total_gas_consumed"], name: "index_cities_on_total_gas_consumed"
    t.index ["total_gas_saved"], name: "index_cities_on_total_gas_saved"
    t.index ["total_water_consumed"], name: "index_cities_on_total_water_consumed"
    t.index ["total_water_saved"], name: "index_cities_on_total_water_saved"
  end

  create_table "city_snapshots", force: :cascade do |t|
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "avg_daily_electricity_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_water_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_gas_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_carbon_consumption_per_user", default: "0.0"
    t.decimal "total_electricity_consumed", default: "0.0"
    t.decimal "total_water_consumed", default: "0.0"
    t.decimal "total_gas_consumed", default: "0.0"
    t.decimal "total_carbon_consumed", default: "0.0"
    t.decimal "max_daily_electricity_consumption", default: "0.0"
    t.decimal "max_daily_water_consumption", default: "0.0"
    t.decimal "max_daily_gas_consumption", default: "0.0"
    t.decimal "max_daily_carbon_consumption", default: "0.0"
    t.integer "electricity_rank"
    t.integer "water_rank"
    t.integer "gas_rank"
    t.integer "carbon_rank"
    t.integer "out_of"
    t.index ["city_id"], name: "index_city_snapshots_on_city_id"
  end

  create_table "counties", force: :cascade do |t|
    t.string "name"
    t.decimal "total_electricity_saved", default: "0.0"
    t.decimal "total_gas_saved", default: "0.0"
    t.decimal "total_water_saved", default: "0.0"
    t.decimal "avg_daily_electricity_consumed_per_capita"
    t.decimal "avg_daily_gas_consumed_per_capita"
    t.decimal "avg_daily_water_consumed_per_capita"
    t.decimal "avg_total_electricity_saved_per_user", default: "0.0"
    t.decimal "avg_total_gas_saved_per_user", default: "0.0"
    t.decimal "avg_total_water_saved_per_user", default: "0.0"
    t.decimal "avg_daily_electricity_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_gas_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_water_consumed_per_user", default: "0.0"
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_electricity_consumed", default: "0.0"
    t.decimal "total_water_consumed", default: "0.0"
    t.decimal "total_gas_consumed", default: "0.0"
    t.decimal "total_carbon_saved", default: "0.0"
    t.decimal "avg_daily_carbon_consumed_per_user", default: "0.0"
    t.decimal "total_carbon_consumed", default: "0.0"
    t.index ["name"], name: "index_counties_on_name", unique: true
    t.index ["region_id"], name: "index_counties_on_region_id"
    t.index ["total_electricity_consumed"], name: "index_counties_on_total_electricity_consumed"
    t.index ["total_electricity_saved"], name: "index_counties_on_total_electricity_saved"
    t.index ["total_gas_consumed"], name: "index_counties_on_total_gas_consumed"
    t.index ["total_gas_saved"], name: "index_counties_on_total_gas_saved"
    t.index ["total_water_consumed"], name: "index_counties_on_total_water_consumed"
    t.index ["total_water_saved"], name: "index_counties_on_total_water_saved"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.decimal "total_electricity_saved", default: "0.0"
    t.decimal "total_gas_saved", default: "0.0"
    t.decimal "total_water_saved", default: "0.0"
    t.decimal "avg_daily_electricity_consumed_per_capita"
    t.decimal "avg_daily_gas_consumed_per_capita"
    t.decimal "avg_daily_water_consumed_per_capita"
    t.decimal "avg_total_electricity_saved_per_user", default: "0.0"
    t.decimal "avg_total_gas_saved_per_user", default: "0.0"
    t.decimal "avg_total_water_saved_per_user", default: "0.0"
    t.decimal "avg_daily_electricity_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_gas_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_water_consumed_per_user", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_electricity_consumed", default: "0.0"
    t.decimal "total_water_consumed", default: "0.0"
    t.decimal "total_gas_consumed", default: "0.0"
    t.decimal "total_carbon_saved", default: "0.0"
    t.decimal "avg_daily_carbon_consumed_per_user", default: "0.0"
    t.decimal "total_carbon_consumed", default: "0.0"
    t.decimal "avg_daily_carbon_consumed_per_capita"
    t.index ["name"], name: "index_countries_on_name", unique: true
    t.index ["total_electricity_consumed"], name: "index_countries_on_total_electricity_consumed"
    t.index ["total_electricity_saved"], name: "index_countries_on_total_electricity_saved"
    t.index ["total_gas_consumed"], name: "index_countries_on_total_gas_consumed"
    t.index ["total_gas_saved"], name: "index_countries_on_total_gas_saved"
    t.index ["total_water_consumed"], name: "index_countries_on_total_water_consumed"
    t.index ["total_water_saved"], name: "index_countries_on_total_water_saved"
  end

  create_table "country_snapshots", force: :cascade do |t|
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "avg_daily_electricity_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_water_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_gas_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_carbon_consumption_per_user", default: "0.0"
    t.decimal "total_electricity_consumed", default: "0.0"
    t.decimal "total_water_consumed", default: "0.0"
    t.decimal "total_gas_consumed", default: "0.0"
    t.decimal "total_carbon_consumed", default: "0.0"
    t.decimal "max_daily_electricity_consumption", default: "0.0"
    t.decimal "max_daily_water_consumption", default: "0.0"
    t.decimal "max_daily_gas_consumption", default: "0.0"
    t.decimal "max_daily_carbon_consumption", default: "0.0"
    t.integer "electricity_rank"
    t.integer "water_rank"
    t.integer "gas_rank"
    t.integer "carbon_rank"
    t.integer "out_of"
    t.decimal "country_avg_carbon"
    t.decimal "country_avg_electricity"
    t.decimal "country_avg_water"
    t.decimal "country_avg_gas"
    t.index ["country_id"], name: "index_country_snapshots_on_country_id"
  end

  create_table "county_snapshots", force: :cascade do |t|
    t.bigint "county_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "avg_daily_electricity_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_water_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_gas_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_carbon_consumption_per_user", default: "0.0"
    t.decimal "total_electricity_consumed", default: "0.0"
    t.decimal "total_water_consumed", default: "0.0"
    t.decimal "total_gas_consumed", default: "0.0"
    t.decimal "total_carbon_consumed", default: "0.0"
    t.decimal "max_daily_electricity_consumption", default: "0.0"
    t.decimal "max_daily_water_consumption", default: "0.0"
    t.decimal "max_daily_gas_consumption", default: "0.0"
    t.decimal "max_daily_carbon_consumption", default: "0.0"
    t.integer "electricity_rank"
    t.integer "water_rank"
    t.integer "gas_rank"
    t.integer "carbon_rank"
    t.integer "out_of"
    t.index ["county_id"], name: "index_county_snapshots_on_county_id"
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
    t.integer "no_residents"
    t.bigint "user_id"
    t.index ["electricity_saved"], name: "index_electric_bills_on_electricity_saved"
    t.index ["house_id"], name: "index_electric_bills_on_house_id"
    t.index ["user_id"], name: "index_electric_bills_on_user_id"
  end

  create_table "electricity_rankings", force: :cascade do |t|
    t.string "area_type"
    t.bigint "area_id"
    t.integer "rank"
    t.boolean "arrow"
    t.index ["area_id", "area_type"], name: "index_electricity_rankings_on_area_id_and_area_type"
    t.index ["area_type", "area_id"], name: "index_electricity_rankings_on_area_type_and_area_id"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "friendships", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "friend_user_id"
    t.index ["friend_user_id", "user_id"], name: "index_friendships_on_friend_user_id_and_user_id", unique: true
    t.index ["user_id", "friend_user_id"], name: "index_friendships_on_user_id_and_friend_user_id", unique: true
  end

  create_table "gas_rankings", force: :cascade do |t|
    t.string "area_type"
    t.bigint "area_id"
    t.integer "rank"
    t.boolean "arrow"
    t.index ["area_id", "area_type"], name: "index_gas_rankings_on_area_id_and_area_type"
    t.index ["area_type", "area_id"], name: "index_gas_rankings_on_area_type_and_area_id"
  end

  create_table "generations", id: false, force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
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

  create_table "heat_bills", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.float "total_therms"
    t.float "price"
    t.float "gas_saved"
    t.bigint "house_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "no_residents"
    t.bigint "user_id"
    t.index ["gas_saved"], name: "index_heat_bills_on_gas_saved"
    t.index ["house_id"], name: "index_heat_bills_on_house_id"
    t.index ["user_id"], name: "index_heat_bills_on_user_id"
  end

  create_table "household_snapshots", force: :cascade do |t|
    t.bigint "house_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "avg_daily_electricity_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_water_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_gas_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_carbon_consumption_per_user", default: "0.0"
    t.decimal "total_electricity_consumed", default: "0.0"
    t.decimal "total_water_consumed", default: "0.0"
    t.decimal "total_gas_consumed", default: "0.0"
    t.decimal "total_carbon_consumed", default: "0.0"
    t.decimal "max_daily_electricity_consumption", default: "0.0"
    t.decimal "max_daily_water_consumption", default: "0.0"
    t.decimal "max_daily_gas_consumption", default: "0.0"
    t.decimal "max_daily_carbon_consumption", default: "0.0"
    t.integer "electricity_rank"
    t.integer "water_rank"
    t.integer "gas_rank"
    t.integer "carbon_rank"
    t.integer "out_of"
    t.index ["house_id"], name: "index_household_snapshots_on_house_id"
  end

  create_table "houses", force: :cascade do |t|
    t.float "total_sq_ft"
    t.integer "no_residents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "address_id"
    t.boolean "apartment", default: false
    t.decimal "avg_daily_electricity_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_water_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_gas_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_carbon_consumed_per_user", default: "0.0"
    t.index ["address_id"], name: "index_houses_on_address_id"
  end

  create_table "neighborhood_snapshots", force: :cascade do |t|
    t.bigint "neighborhood_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "avg_daily_electricity_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_water_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_gas_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_carbon_consumption_per_user", default: "0.0"
    t.decimal "total_electricity_consumed", default: "0.0"
    t.decimal "total_water_consumed", default: "0.0"
    t.decimal "total_gas_consumed", default: "0.0"
    t.decimal "total_carbon_consumed", default: "0.0"
    t.decimal "max_daily_electricity_consumption", default: "0.0"
    t.decimal "max_daily_water_consumption", default: "0.0"
    t.decimal "max_daily_gas_consumption", default: "0.0"
    t.decimal "max_daily_carbon_consumption", default: "0.0"
    t.integer "electricity_rank"
    t.integer "water_rank"
    t.integer "gas_rank"
    t.integer "carbon_rank"
    t.integer "out_of"
    t.index ["neighborhood_id"], name: "index_neighborhood_snapshots_on_neighborhood_id"
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string "name"
    t.decimal "total_electricity_saved", default: "0.0"
    t.decimal "total_gas_saved", default: "0.0"
    t.decimal "total_water_saved", default: "0.0"
    t.decimal "avg_daily_electricity_consumed_per_capita"
    t.decimal "avg_daily_gas_consumed_per_capita"
    t.decimal "avg_daily_water_consumed_per_capita"
    t.decimal "avg_total_electricity_saved_per_user", default: "0.0"
    t.decimal "avg_total_gas_saved_per_user", default: "0.0"
    t.decimal "avg_total_water_saved_per_user", default: "0.0"
    t.decimal "avg_daily_electricity_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_gas_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_water_consumed_per_user", default: "0.0"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_electricity_consumed", default: "0.0"
    t.decimal "total_water_consumed", default: "0.0"
    t.decimal "total_gas_consumed", default: "0.0"
    t.decimal "total_carbon_saved", default: "0.0"
    t.decimal "avg_daily_carbon_consumed_per_user", default: "0.0"
    t.decimal "total_carbon_consumed", default: "0.0"
    t.index ["city_id"], name: "index_neighborhoods_on_city_id"
    t.index ["name"], name: "index_neighborhoods_on_name", unique: true
    t.index ["total_electricity_consumed"], name: "index_neighborhoods_on_total_electricity_consumed"
    t.index ["total_electricity_saved"], name: "index_neighborhoods_on_total_electricity_saved"
    t.index ["total_gas_consumed"], name: "index_neighborhoods_on_total_gas_consumed"
    t.index ["total_gas_saved"], name: "index_neighborhoods_on_total_gas_saved"
    t.index ["total_water_consumed"], name: "index_neighborhoods_on_total_water_consumed"
    t.index ["total_water_saved"], name: "index_neighborhoods_on_total_water_saved"
  end

  create_table "region_snapshots", force: :cascade do |t|
    t.bigint "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "avg_daily_electricity_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_water_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_gas_consumption_per_user", default: "0.0"
    t.decimal "avg_daily_carbon_consumption_per_user", default: "0.0"
    t.decimal "total_electricity_consumed", default: "0.0"
    t.decimal "total_water_consumed", default: "0.0"
    t.decimal "total_gas_consumed", default: "0.0"
    t.decimal "total_carbon_consumed", default: "0.0"
    t.decimal "max_daily_electricity_consumption", default: "0.0"
    t.decimal "max_daily_water_consumption", default: "0.0"
    t.decimal "max_daily_gas_consumption", default: "0.0"
    t.decimal "max_daily_carbon_consumption", default: "0.0"
    t.integer "electricity_rank"
    t.integer "water_rank"
    t.integer "gas_rank"
    t.integer "carbon_rank"
    t.integer "out_of"
    t.index ["region_id"], name: "index_region_snapshots_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.decimal "total_electricity_saved", default: "0.0"
    t.decimal "total_gas_saved", default: "0.0"
    t.decimal "total_water_saved", default: "0.0"
    t.decimal "avg_daily_electricity_consumed_per_capita"
    t.decimal "avg_daily_gas_consumed_per_capita"
    t.decimal "avg_daily_water_consumed_per_capita"
    t.decimal "avg_total_electricity_saved_per_user", default: "0.0"
    t.decimal "avg_total_gas_saved_per_user", default: "0.0"
    t.decimal "avg_total_water_saved_per_user", default: "0.0"
    t.decimal "avg_daily_electricity_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_gas_consumed_per_user", default: "0.0"
    t.decimal "avg_daily_water_consumed_per_user", default: "0.0"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_electricity_consumed", default: "0.0"
    t.decimal "total_water_consumed", default: "0.0"
    t.decimal "total_gas_consumed", default: "0.0"
    t.decimal "total_carbon_saved", default: "0.0"
    t.decimal "avg_daily_carbon_consumed_per_user", default: "0.0"
    t.decimal "total_carbon_consumed", default: "0.0"
    t.decimal "avg_daily_carbon_consumed_per_capita", default: "0.0"
    t.index ["country_id"], name: "index_regions_on_country_id"
    t.index ["name"], name: "index_regions_on_name", unique: true
    t.index ["total_electricity_consumed"], name: "index_regions_on_total_electricity_consumed"
    t.index ["total_electricity_saved"], name: "index_regions_on_total_electricity_saved"
    t.index ["total_gas_consumed"], name: "index_regions_on_total_gas_consumed"
    t.index ["total_gas_saved"], name: "index_regions_on_total_gas_saved"
    t.index ["total_water_consumed"], name: "index_regions_on_total_water_consumed"
    t.index ["total_water_saved"], name: "index_regions_on_total_water_saved"
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

  create_table "user_carbon_rankings", force: :cascade do |t|
    t.integer "rank"
    t.boolean "arrow"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "area_type"
    t.bigint "area_id"
    t.index ["area_id", "area_type"], name: "index_user_carbon_rankings_on_area_id_and_area_type"
    t.index ["area_type", "area_id"], name: "index_user_carbon_rankings_on_area_type_and_area_id"
    t.index ["user_id"], name: "index_user_carbon_rankings_on_user_id"
  end

  create_table "user_electricity_questions", force: :cascade do |t|
    t.integer "a_count", default: 0
    t.integer "q_count", default: 4
    t.string "quest1"
    t.string "quest2"
    t.string "quest3"
    t.string "quest4"
    t.string "quest5"
    t.bigint "house_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "completion_percentage"
    t.boolean "completed", default: false
    t.index ["house_id"], name: "index_user_electricity_questions_on_house_id"
    t.index ["user_id"], name: "index_user_electricity_questions_on_user_id"
  end

  create_table "user_electricity_rankings", force: :cascade do |t|
    t.integer "rank"
    t.boolean "arrow"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "area_type"
    t.bigint "area_id"
    t.index ["area_id", "area_type"], name: "index_user_electricity_rankings_on_area_id_and_area_type"
    t.index ["area_type", "area_id"], name: "index_user_electricity_rankings_on_area_type_and_area_id"
    t.index ["user_id"], name: "index_user_electricity_rankings_on_user_id"
  end

  create_table "user_gas_questions", force: :cascade do |t|
    t.integer "a_count", default: 0
    t.integer "q_count", default: 5
    t.string "quest1"
    t.string "quest2"
    t.string "quest3"
    t.string "quest4"
    t.string "quest5"
    t.string "quest6"
    t.bigint "house_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "completion_percentage"
    t.boolean "completed", default: false
    t.index ["house_id"], name: "index_user_gas_questions_on_house_id"
    t.index ["user_id"], name: "index_user_gas_questions_on_user_id"
  end

  create_table "user_gas_rankings", force: :cascade do |t|
    t.integer "rank"
    t.boolean "arrow"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "area_type"
    t.bigint "area_id"
    t.index ["area_id", "area_type"], name: "index_user_gas_rankings_on_area_id_and_area_type"
    t.index ["area_type", "area_id"], name: "index_user_gas_rankings_on_area_type_and_area_id"
    t.index ["user_id"], name: "index_user_gas_rankings_on_user_id"
  end

  create_table "user_generations", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id", "parent_id"], name: "index_user_generations_on_child_id_and_parent_id", unique: true
    t.index ["parent_id", "child_id"], name: "index_user_generations_on_parent_id_and_child_id", unique: true
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
    t.datetime "move_in_date"
    t.index ["house_id"], name: "index_user_houses_on_house_id"
    t.index ["user_id"], name: "index_user_houses_on_user_id"
  end

  create_table "user_invites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "invite_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invite_id", "user_id"], name: "index_user_invites_on_invite_id_and_user_id", unique: true
    t.index ["user_id", "invite_id"], name: "index_user_invites_on_user_id_and_invite_id", unique: true
  end

  create_table "user_logs", force: :cascade do |t|
    t.time "time"
    t.bigint "user_id"
    t.string "action"
    t.string "page"
    t.string "next_page"
    t.string "detail"
    t.string "description"
    t.integer "num"
    t.string "msg"
    t.index ["user_id"], name: "index_user_logs_on_user_id"
  end

  create_table "user_request_areas", force: :cascade do |t|
    t.string "area_type"
    t.bigint "area_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_type", "area_id"], name: "index_user_request_areas_on_area_type_and_area_id"
    t.index ["user_id"], name: "index_user_request_areas_on_user_id"
  end

  create_table "user_water_questions", force: :cascade do |t|
    t.integer "a_count", default: 0
    t.integer "q_count", default: 4
    t.string "quest1"
    t.string "quest2"
    t.string "quest3"
    t.string "quest4"
    t.string "quest5"
    t.bigint "house_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "completion_percentage"
    t.boolean "completed", default: false
    t.index ["house_id"], name: "index_user_water_questions_on_house_id"
    t.index ["user_id"], name: "index_user_water_questions_on_user_id"
  end

  create_table "user_water_rankings", force: :cascade do |t|
    t.integer "rank"
    t.boolean "arrow"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "area_type"
    t.bigint "area_id"
    t.index ["area_id", "area_type"], name: "index_user_water_rankings_on_area_id_and_area_type"
    t.index ["area_type", "area_id"], name: "index_user_water_rankings_on_area_type_and_area_id"
    t.index ["user_id"], name: "index_user_water_rankings_on_user_id"
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
    t.decimal "total_electricitybill_days_logged"
    t.decimal "total_electricity_savings"
    t.decimal "total_gallons_logged"
    t.decimal "total_waterbill_days_logged"
    t.decimal "total_water_savings"
    t.decimal "total_therms_logged"
    t.decimal "total_heatbill_days_logged"
    t.decimal "total_gas_savings"
    t.decimal "total_carbon_savings"
    t.decimal "total_pounds_logged"
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.string "invite_token"
    t.integer "parent_id"
    t.integer "generation"
    t.datetime "last_login"
    t.integer "total_logins"
    t.float "avg_time_btw_logins"
    t.boolean "privacy_policy", default: false
    t.string "filename"
    t.integer "invite_max", default: 3
    t.datetime "accepted_date"
    t.datetime "completed_signup_date"
    t.string "slug"
    t.index ["total_electricity_savings"], name: "index_users_on_total_electricity_savings"
    t.index ["total_gas_savings"], name: "index_users_on_total_gas_savings"
    t.index ["total_water_savings"], name: "index_users_on_total_water_savings"
  end

  create_table "water_bills", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.float "total_gallons"
    t.float "price"
    t.float "water_saved"
    t.bigint "house_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "no_residents"
    t.bigint "user_id"
    t.index ["house_id"], name: "index_water_bills_on_house_id"
    t.index ["user_id"], name: "index_water_bills_on_user_id"
    t.index ["water_saved"], name: "index_water_bills_on_water_saved"
  end

  create_table "water_rankings", force: :cascade do |t|
    t.string "area_type"
    t.bigint "area_id"
    t.integer "rank"
    t.boolean "arrow"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["area_id", "area_type"], name: "index_water_rankings_on_area_id_and_area_type"
    t.index ["area_type", "area_id"], name: "index_water_rankings_on_area_type_and_area_id"
  end

  create_table "zipcodes", force: :cascade do |t|
    t.string "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "addresses", "cities"
  add_foreign_key "addresses", "counties"
  add_foreign_key "addresses", "neighborhoods"
  add_foreign_key "addresses", "zipcodes"
  add_foreign_key "admins", "users"
  add_foreign_key "cities", "regions"
  add_foreign_key "city_snapshots", "cities"
  add_foreign_key "counties", "regions"
  add_foreign_key "country_snapshots", "countries"
  add_foreign_key "county_snapshots", "counties"
  add_foreign_key "electric_bills", "houses"
  add_foreign_key "electric_bills", "users"
  add_foreign_key "groups", "admins"
  add_foreign_key "heat_bills", "houses"
  add_foreign_key "heat_bills", "users"
  add_foreign_key "household_snapshots", "houses"
  add_foreign_key "houses", "addresses"
  add_foreign_key "neighborhood_snapshots", "neighborhoods"
  add_foreign_key "neighborhoods", "cities"
  add_foreign_key "region_snapshots", "regions"
  add_foreign_key "regions", "countries"
  add_foreign_key "trips", "days"
  add_foreign_key "trips", "users"
  add_foreign_key "user_carbon_rankings", "users"
  add_foreign_key "user_electricity_questions", "houses"
  add_foreign_key "user_electricity_questions", "users"
  add_foreign_key "user_electricity_rankings", "users"
  add_foreign_key "user_gas_questions", "houses"
  add_foreign_key "user_gas_questions", "users"
  add_foreign_key "user_gas_rankings", "users"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
  add_foreign_key "user_houses", "houses"
  add_foreign_key "user_houses", "users"
  add_foreign_key "user_logs", "users"
  add_foreign_key "user_request_areas", "users"
  add_foreign_key "user_water_questions", "houses"
  add_foreign_key "user_water_questions", "users"
  add_foreign_key "user_water_rankings", "users"
  add_foreign_key "water_bills", "houses"
  add_foreign_key "water_bills", "users"
end
