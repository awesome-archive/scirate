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

ActiveRecord::Schema.define(version: 20140116142259) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arxiv_authors", force: true do |t|
    t.integer "arxiv_paper_id", null: false
    t.integer "position",       null: false
    t.string  "fullname",       null: false
    t.string  "searchterm",     null: false
  end

  add_index "arxiv_authors", ["arxiv_paper_id"], name: "index_arxiv_authors_on_arxiv_paper_id", using: :btree
  add_index "arxiv_authors", ["searchterm"], name: "index_arxiv_authors_on_searchterm", using: :btree

  create_table "arxiv_categories", force: true do |t|
    t.integer "arxiv_paper_id", null: false
    t.integer "position",       null: false
    t.string  "category",       null: false
  end

  add_index "arxiv_categories", ["arxiv_paper_id"], name: "index_arxiv_categories_on_arxiv_paper_id", using: :btree
  add_index "arxiv_categories", ["category"], name: "index_arxiv_categories_on_category", using: :btree

  create_table "arxiv_papers", force: true do |t|
    t.string   "identifier",                 null: false
    t.string   "submitter",                  null: false
    t.string   "title",                      null: false
    t.text     "abstract",                   null: false
    t.text     "comments"
    t.string   "msc_class"
    t.string   "report_no"
    t.string   "journal_ref"
    t.string   "doi"
    t.string   "proxy"
    t.string   "license"
    t.datetime "submit_date",                null: false
    t.datetime "update_date",                null: false
    t.string   "abs_url",                    null: false
    t.string   "pdf_url",                    null: false
    t.boolean  "delta",       default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "arxiv_papers", ["delta"], name: "index_arxiv_papers_on_delta", using: :btree
  add_index "arxiv_papers", ["identifier"], name: "index_arxiv_papers_on_identifier", using: :btree

  create_table "arxiv_versions", force: true do |t|
    t.integer  "arxiv_paper_id", null: false
    t.integer  "position",       null: false
    t.datetime "date",           null: false
    t.datetime "size",           null: false
  end

  add_index "arxiv_versions", ["arxiv_paper_id"], name: "index_arxiv_versions_on_arxiv_paper_id", using: :btree

  create_table "comment_reports", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: true do |t|
    t.integer  "paper_id",                          null: false
    t.string   "paper_type",                        null: false
    t.integer  "user_id",                           null: false
    t.integer  "score",             default: 0,     null: false
    t.integer  "cached_votes_up",   default: 0,     null: false
    t.integer  "cached_votes_down", default: 0,     null: false
    t.boolean  "hidden",            default: false, null: false
    t.integer  "parent_id"
    t.integer  "ancestor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["ancestor_id"], name: "index_comments_on_ancestor_id", using: :btree
  add_index "comments", ["paper_id", "paper_type"], name: "index_comments_on_paper_id_and_paper_type", using: :btree
  add_index "comments", ["parent_id"], name: "index_comments_on_parent_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "down_votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "downvotes", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feed_preferences", force: true do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.datetime "last_visited"
    t.datetime "previous_last_visited"
    t.integer  "selected_range"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", force: true do |t|
    t.string   "identifier",                      null: false
    t.string   "source",                          null: false
    t.string   "name",                            null: false
    t.integer  "parent_id"
    t.integer  "position",            default: 0, null: false
    t.integer  "subscriptions_count", default: 0, null: false
    t.datetime "last_paper_date"
  end

  add_index "feeds", ["identifier"], name: "index_feeds_on_identifier", using: :btree
  add_index "feeds", ["parent_id"], name: "index_feeds_on_parent_id", using: :btree
  add_index "feeds", ["source"], name: "index_feeds_on_source", using: :btree

  create_table "scites", force: true do |t|
    t.integer "paper_id",   null: false
    t.string  "paper_type", null: false
    t.integer "user_id",    null: false
  end

  add_index "scites", ["paper_id", "paper_type"], name: "index_scites_on_paper_id_and_paper_type", using: :btree
  add_index "scites", ["user_id"], name: "index_scites_on_user_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "subscriptions", ["feed_id"], name: "index_subscriptions_on_feed_id", using: :btree
  add_index "subscriptions", ["user_id", "feed_id"], name: "index_subscriptions_on_user_id_and_feed_id", unique: true, using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "up_votes", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "upvotes", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "remember_token"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "password_digest"
    t.integer  "scites_count",           default: 0
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "confirmation_token"
    t.boolean  "active",                 default: false
    t.integer  "comments_count",         default: 0
    t.datetime "confirmation_sent_at"
    t.integer  "subscriptions_count",    default: 0
    t.boolean  "expand_abstracts",       default: false
    t.string   "account_status",         default: "user"
    t.text     "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "vote_weight"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["votable_id", "votable_type"], name: "index_votes_on_votable_id_and_votable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type", using: :btree

end
