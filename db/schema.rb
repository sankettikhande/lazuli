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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131206075308) do

  create_table "channel_courses", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "course_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.boolean  "permission_watch"
    t.boolean  "permission_create"
    t.boolean  "permission_share"
  end

  add_index "channel_courses", ["channel_id"], :name => "index_channel_courses_on_channel_id"
  add_index "channel_courses", ["course_id"], :name => "index_channel_courses_on_course_id"

  create_table "channel_subscriptions", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "subscription_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "channel_subscriptions", ["channel_id"], :name => "index_channel_subscriptions_on_channel_id"
  add_index "channel_subscriptions", ["subscription_id"], :name => "index_channel_subscriptions_on_subscription_id"

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.integer  "admin_user_id"
    t.integer  "created_by"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "contact_number"
    t.string   "email"
    t.string   "user_name"
    t.string   "channel_type"
    t.string   "company_name"
    t.string   "company_address"
    t.string   "company_description"
    t.string   "company_number"
    t.string   "company_contact_name"
    t.string   "company_postal_address"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "channels", ["admin_user_id"], :name => "index_channels_on_admin_user_id"

  create_table "course_permissions", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "course_id"
    t.boolean  "watch"
    t.boolean  "produce"
    t.boolean  "share"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "created_by"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "trainer_name"
    t.string   "trainer_biography"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "courses", ["created_by"], :name => "index_courses_on_created_by"

  create_table "subscriptions", :force => true do |t|
    t.string   "name"
    t.integer  "days"
    t.integer  "months"
    t.integer  "years"
    t.integer  "calculated_days"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "topics", :force => true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.integer  "channel_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_channel_subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subscription_id"
    t.integer  "channel_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.date     "subscription_date"
    t.date     "expiry_date"
    t.integer  "course_id"
    t.boolean  "permission_watch"
    t.boolean  "permission_create"
    t.boolean  "permission_share"
  end

  create_table "user_permissions", :force => true do |t|
    t.integer  "channel_id"
    t.integer  "course_id"
    t.integer  "user_id"
    t.boolean  "watch"
    t.boolean  "produce"
    t.boolean  "share"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "user_channel_subscription_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "phone_number"
    t.string   "company_name"
    t.string   "address"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
