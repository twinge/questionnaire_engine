class AddIndexesToAnswers < ActiveRecord::Migration
  def self.up
    add_index Qe::Answer.table_name, :answer_sheet_id
    add_index Qe::Answer.table_name, :question_id
  end

  def self.down
    remove_index Qe::Answer.table_name, :answer_sheet_id
    remove_index Qe::Answer.table_name, :question_id
  end
end