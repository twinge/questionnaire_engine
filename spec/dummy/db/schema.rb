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

ActiveRecord::Schema.define(:version => 20120905143432) do

  create_table "pr_answer_sheet_question_sheets", :force => true do |t|
    t.integer  "answer_sheet_id"
    t.integer  "question_sheet_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "pr_answer_sheet_question_sheets", ["answer_sheet_id"], :name => "index_pr_answer_sheet_question_sheets_on_answer_sheet_id"
  add_index "pr_answer_sheet_question_sheets", ["question_sheet_id"], :name => "index_pr_answer_sheet_question_sheets_on_question_sheet_id"

  create_table "pr_answer_sheets", :force => true do |t|
    t.integer  "question_sheet_id"
    t.datetime "completed_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "pr_answers", :force => true do |t|
    t.integer  "answer_sheet_id",         :null => false
    t.integer  "question_id",             :null => false
    t.text     "value"
    t.string   "short_value"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "attachment_file_size"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.datetime "attachment_updated_at"
  end

  add_index "pr_answers", ["answer_sheet_id"], :name => "index_pr_answers_on_answer_sheet_id"
  add_index "pr_answers", ["question_id"], :name => "index_pr_answers_on_question_id"
  add_index "pr_answers", ["short_value"], :name => "index_pr_answers_on_short_value"

  create_table "pr_conditions", :force => true do |t|
    t.integer "question_sheet_id", :null => false
    t.integer "trigger_id",        :null => false
    t.string  "expression",        :null => false
    t.integer "toggle_page_id",    :null => false
    t.integer "toggle_id"
  end

  create_table "pr_elements", :force => true do |t|
    t.string   "kind",                      :limit => 40,                    :null => false
    t.string   "style",                     :limit => 40
    t.string   "label"
    t.text     "content"
    t.boolean  "required"
    t.string   "slug",                      :limit => 36
    t.integer  "position"
    t.string   "object_name"
    t.string   "attribute_name"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
    t.string   "source"
    t.string   "value_xpath"
    t.string   "text_xpath"
    t.integer  "question_grid_id"
    t.string   "cols"
    t.boolean  "no_cache",                                :default => false
    t.boolean  "is_confidential"
    t.string   "total_cols"
    t.string   "css_id"
    t.string   "css_class"
    t.integer  "related_question_sheet_id"
    t.integer  "conditional_id"
    t.text     "tooltip"
    t.boolean  "hide_label",                              :default => false
    t.boolean  "hide_option_labels",                      :default => false
    t.integer  "max_length"
  end

  add_index "pr_elements", ["conditional_id"], :name => "index_pr_elements_on_conditional_id"
  add_index "pr_elements", ["position"], :name => "index_pr_elements_on_question_sheet_id_and_position_and_page_id"
  add_index "pr_elements", ["question_grid_id"], :name => "index_pr_elements_on_question_grid_id"
  add_index "pr_elements", ["slug"], :name => "index_pr_elements_on_slug"

  create_table "pr_email_templates", :force => true do |t|
    t.string   "name",       :limit => 1000, :null => false
    t.text     "content"
    t.boolean  "enabled"
    t.string   "subject"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "pr_email_templates", ["name"], :name => "index_pr_email_templates_on_name", :length => {"name"=>255}

  create_table "pr_page_elements", :force => true do |t|
    t.integer  "page_id"
    t.integer  "element_id"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pr_pages", :force => true do |t|
    t.integer  "question_sheet_id",                                   :null => false
    t.string   "label",             :limit => 100,                    :null => false
    t.integer  "number"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.boolean  "hidden",                           :default => false
  end

  create_table "pr_question_sheets", :force => true do |t|
    t.string  "label",    :limit => 60,                    :null => false
    t.boolean "archived",               :default => false
  end

  create_table "pr_reference_sheets", :force => true do |t|
    t.integer  "question_id"
    t.integer  "applicant_answer_sheet_id"
    t.datetime "email_sent_at"
    t.string   "relationship"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.string   "status"
    t.datetime "submitted_at"
    t.string   "access_key"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

end
