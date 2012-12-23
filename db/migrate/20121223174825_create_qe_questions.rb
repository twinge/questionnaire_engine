class CreateQeQuestions < ActiveRecord::Migration
  def change
    create_table Qe::Question.table_name do |t|
      t.column :label,    :string,  :limit => 60,       :null => false
      t.column :archived, :boolean, :default => false,  :nil => false

      t.timestamps
    end
  end
end
