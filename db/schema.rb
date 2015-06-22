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

ActiveRecord::Schema.define(version: 20150622174318) do

  create_table "contacts", force: :cascade do |t|
    t.string   "nom",        null: false
    t.string   "prenom",     null: false
    t.string   "email",      null: false
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id"

  create_table "datafiles", force: :cascade do |t|
    t.string   "nom"
    t.string   "type_contenu"
    t.string   "extension"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "datafiles", ["nom"], name: "index_datafiles_on_nom", unique: true

  create_table "file_version_relations", force: :cascade do |t|
    t.integer  "fichier_id"
    t.integer  "version_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "file_version_relations", ["fichier_id", "version_id"], name: "index_file_version_relations_on_fichier_id_and_version_id", unique: true
  add_index "file_version_relations", ["fichier_id"], name: "index_file_version_relations_on_fichier_id"
  add_index "file_version_relations", ["version_id"], name: "index_file_version_relations_on_version_id"

  create_table "microposts", force: :cascade do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "microposts", ["user_id"], name: "index_microposts_on_user_id"

  create_table "project_user_relations", force: :cascade do |t|
    t.integer  "membre_id"
    t.integer  "projet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "project_user_relations", ["membre_id", "projet_id"], name: "index_project_user_relations_on_membre_id_and_projet_id", unique: true
  add_index "project_user_relations", ["membre_id"], name: "index_project_user_relations_on_membre_id"
  add_index "project_user_relations", ["projet_id"], name: "index_project_user_relations_on_projet_id"

  create_table "projects", force: :cascade do |t|
    t.string   "nom"
    t.datetime "datedebut"
    t.integer  "etat",       default: 0, null: false
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id"

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "password"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "users", ["login"], name: "index_users_on_login"

  create_table "versions", force: :cascade do |t|
    t.string   "nom"
    t.string   "chemin"
    t.integer  "datafile_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
