# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_230_820_004_827) do
  create_table 'auth_identities', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.string 'provider', null: false
    t.string 'login', null: false
    t.string 'token'
    t.string 'uid'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_auth_identities_on_user_id'
  end

  create_table 'tasks', force: :cascade do |t|
    t.string 'public_id'
    t.string 'title'
    t.text 'description'
    t.boolean 'completed'
    t.integer 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'jira_id'
    t.index ['user_id'], name: 'index_tasks_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'full_name'
    t.string 'public_id'
    t.integer 'role'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'auth_identities', 'users'
  add_foreign_key 'tasks', 'users'
end
