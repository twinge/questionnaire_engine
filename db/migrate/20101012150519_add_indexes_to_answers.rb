class AddIndexesToAnswers < ActiveRecord::Migration
  def self.up
    add_index :qe_answers, :answer_sheet_id
    add_index :qe_answers, :question_id
  end

  def self.down
    remove_index :qe_answers, :answer_sheet_id
    remove_index :qe_answers, :question_id
  end
end