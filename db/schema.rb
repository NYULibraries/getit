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

ActiveRecord::Schema.define(version: 20160706162031) do

  create_table "clickthroughs", force: true do |t|
    t.integer  "request_id",          default: 0, null: false
    t.integer  "service_response_id", default: 0, null: false
    t.datetime "created_at",                      null: false
  end

  add_index "clickthroughs", ["created_at"], name: "click_created_idx", using: :btree
  add_index "clickthroughs", ["request_id"], name: "click_req_id", using: :btree
  add_index "clickthroughs", ["service_response_id"], name: "click_serv_resp_idx", using: :btree

  create_table "dispatched_services", force: true do |t|
    t.integer  "request_id",     default: 0,   null: false
    t.string   "service_id",     default: "0", null: false
    t.datetime "updated_at",                   null: false
    t.text     "exception_info"
    t.string   "status",                       null: false
    t.datetime "created_at"
  end

  add_index "dispatched_services", ["request_id", "service_id"], name: "dptch_request_id", using: :btree

  create_table "permalinks", force: true do |t|
    t.integer "referent_id",                        default: 0
    t.date    "created_on",                                     null: false
    t.text    "context_obj_serialized"
    t.string  "orig_rfr_id",            limit: 256
    t.date    "last_access"
  end

  add_index "permalinks", ["referent_id"], name: "plink_referent_idx", using: :btree

  create_table "referent_values", force: true do |t|
    t.integer  "referent_id",                 default: 0,     null: false
    t.string   "key_name",         limit: 50, default: "",    null: false
    t.text     "value"
    t.string   "normalized_value"
    t.boolean  "metadata",                    default: false, null: false
    t.boolean  "private_data",                default: false, null: false
    t.datetime "created_at"
  end

  add_index "referent_values", ["key_name", "normalized_value"], name: "by_name_and_normal_val", using: :btree
  add_index "referent_values", ["referent_id", "key_name", "normalized_value"], name: "rft_val_referent_idx", using: :btree

  create_table "referents", force: true do |t|
    t.string   "atitle"
    t.string   "title"
    t.string   "issn",       limit: 10
    t.string   "isbn",       limit: 13
    t.string   "year",       limit: 4
    t.string   "volume",     limit: 10
    t.datetime "created_at"
  end

  add_index "referents", ["atitle", "title", "issn", "isbn", "year", "volume"], name: "rft_shortcut_idx", using: :btree
  add_index "referents", ["isbn"], name: "index_referents_on_isbn", using: :btree
  add_index "referents", ["issn", "year", "volume"], name: "by_issn", using: :btree
  add_index "referents", ["title"], name: "index_referents_on_title", using: :btree
  add_index "referents", ["volume"], name: "index_referents_on_volume", using: :btree
  add_index "referents", ["year", "volume"], name: "by_year", using: :btree

  create_table "requests", force: true do |t|
    t.string   "session_id",             limit: 100, default: "", null: false
    t.integer  "referent_id",                        default: 0,  null: false
    t.string   "referrer_id"
    t.datetime "created_at",                                      null: false
    t.string   "client_ip_addr"
    t.boolean  "client_ip_is_simulated"
    t.string   "contextobj_fingerprint", limit: 32
    t.text     "http_env"
  end

  add_index "requests", ["client_ip_addr"], name: "index_requests_on_client_ip_addr", using: :btree
  add_index "requests", ["contextobj_fingerprint"], name: "index_requests_on_contextobj_fingerprint", using: :btree
  add_index "requests", ["created_at"], name: "req_created_at", using: :btree
  add_index "requests", ["referent_id", "referrer_id"], name: "context_object_idx", using: :btree
  add_index "requests", ["session_id"], name: "req_sess_idx", using: :btree

  create_table "service_responses", force: true do |t|
    t.string   "service_id",              limit: 25,                null: false
    t.string   "response_key",                         default: ""
    t.string   "value_string"
    t.string   "value_alt_string"
    t.text     "value_text"
    t.string   "display_text"
    t.string   "url",                     limit: 4000
    t.text     "notes"
    t.text     "service_data"
    t.datetime "created_at"
    t.string   "service_type_value_name"
    t.integer  "request_id"
  end

  add_index "service_responses", ["request_id"], name: "index_service_responses_on_request_id", using: :btree
  add_index "service_responses", ["service_id", "response_key", "value_string", "value_alt_string"], name: "svc_resp_service_id", using: :btree

  create_table "sfx_urls", force: true do |t|
    t.string "url"
  end

  add_index "sfx_urls", ["url"], name: "index_sfx_urls_on_url", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "refreshed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sign_in_count",      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider",           default: "", null: false
    t.string   "aleph_id"
    t.string   "institution_code"
    t.string   "patron_status"
    t.string   "barcode"
  end

  add_index "users", ["username", "provider"], name: "index_users_on_username_and_provider", unique: true, using: :btree

end
