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

ActiveRecord::Schema.define(:version => 20120810034555) do

  create_table "answers", :force => true do |t|
    t.text     "body",                              :null => false
    t.integer  "creator_id",                        :null => false
    t.integer  "question_id",                       :null => false
    t.integer  "upvote_count",   :default => 0
    t.integer  "downvote_count", :default => 0
    t.boolean  "is_flagged",     :default => false
    t.boolean  "is_active",      :default => true
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "creator_id"
    t.integer  "target_id"
    t.integer  "target_type"
    t.boolean  "is_flagged"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "moderators_tags", :force => true do |t|
    t.integer "tag_id"
    t.integer "moderator_id"
  end

  create_table "opinions", :force => true do |t|
    t.string   "optype",       :null => false
    t.integer  "creator_id",   :null => false
    t.integer  "score_change", :null => false
    t.integer  "target_id",    :null => false
    t.string   "target_type",  :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "questions", :force => true do |t|
    t.string   "title",                             :null => false
    t.text     "description",                       :null => false
    t.integer  "creator_id",                        :null => false
    t.integer  "upvote_count",   :default => 0
    t.integer  "downvote_count", :default => 0
    t.boolean  "is_closed",      :default => false
    t.boolean  "is_active",      :default => true
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "questions_tags", :force => true do |t|
    t.integer "question_id"
    t.integer "tag_id"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "target_id"
    t.string   "target_type"
    t.integer  "subscriber_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "tag_priviledges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.integer  "priviledge"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "creator_id"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "user_name",                              :null => false
    t.string   "first_name",                             :null => false
    t.string   "mid_name"
    t.string   "last_name",                              :null => false
    t.text     "address"
    t.string   "role"
    t.string   "city"
    t.string   "zip"
    t.string   "country"
    t.string   "gender"
    t.integer  "reputation"
    t.boolean  "is_active"
    t.string   "signature"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
