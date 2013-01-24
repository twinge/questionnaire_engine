class CreateQeCore < ActiveRecord::Migration
  def change

    if table_exists?(:question_sheets)
      rename_table(:question_sheet, Qe::QuestionSheet.table_name)
    else
      create_table Qe::QuestionSheet.table_name do |t|
        t.string :label,     :limit => 100,       :null => false   # name used internally in admin
        t.boolean :archived, :default => false,  :nil => false

        t.timestamps
      end
    end


    if table_exists?(:pages)
      rename_table(:pages, Qe::Page.table_name)
    else
      create_table Qe::Page.table_name do |t|
        t.integer :question_sheet_id,  :null => false

        t.string  :label,     :limit => 60, :null => false    # page title
        t.integer :number                                     # page number (order)
        t.boolean :no_cache,  :default => false
        t.boolean :hidden,    :default => false

        t.timestamps
      end
    end


    if table_exists?(:elements)
      rename_table(:elements, Qe::Element.table_name)
    else
      create_table Qe::Element.table_name do |t|
        t.integer :question_grid_id,  :null => true

        t.string :kind,               :limit => 40,   :null => false  # single table inheritance: class name
        t.string :style,              :limit => 40                    # render style
        t.string :label,              :limit => 255                   # question label, section heading
        t.text :content,              :null => true                   # for content/instructions, and for choices (one per line)
        t.boolean :required                                           # question is required?
        t.string :slug,               :limit => 36                    # variable reference
        t.integer :position
        t.string :object_name,        :attribute_name
        t.string :source
        t.string :value_xpath
        t.string :text_path
        t.string :cols
        t.boolean :is_confidential, :default => false
        t.string :total_cols
        t.string :css_id
        t.string :css_class

        t.timestamps
      end
      add_index Qe::Element.table_name, :slug
    end


    if table_exists?(:page_elements)
      rename_table(:page_elements, Qe::PageElement.table_name)
    else
      create_table Qe::PageElement.table_name do |t|
        t.integer :page_id
        t.integer :element_id
        t.integer :position

        t.timestamps
      end
    end

    # takes up more than 64 characters
    # add_index Qe::Element.table_name, [:qe_question_sheet_id, :position, :qe_page_id], :unique => false


    if table_exists?(:answer_sheets)
      rename_table(:answer_sheet, Qe::AnswerSheet.table_name)
    else
      create_table Qe::AnswerSheet.table_name do |t|
        t.integer   :question_sheet_id,  :null => false
        t.datetime  :completed_at,          :null => true  # null if incomplete

        t.timestamps
      end
    end


    if table_exists?(:answers)
      rename_table(:answers, Qe::Answer.table_name)
    else
      create_table Qe::Answer.table_name do |t|
        t.integer :answer_sheet_id,  :null => false
        t.integer :question_id,      :null => false

        t.text    :value
        t.string  :short_value,         :null => true, :limit => 255   # indexed copy of :response
        t.integer :size
        t.string  :content_type
        t.string  :filename
        t.integer :height
        t.integer :width
        t.integer :parent_id
        t.string  :thumbnail

        t.timestamps
      end
      add_index Qe::Answer.table_name, :short_value
    end


    if table_exists?(:conditions)
      rename_table(:conditions, Qe::Condition.table_name)
    else
      create_table Qe::Condition.table_name do |t|
        t.integer :question_sheet_id,  :null => false
        t.integer :trigger_id,            :null => false
        t.string  :expression,            :null => false,  :limit  => 255
        t.integer :toggle_page_id,        :null => false
        t.integer :toggle_id,             :null => true    # null if toggles whole page

        t.timestamps
      end
    end

  end
end
