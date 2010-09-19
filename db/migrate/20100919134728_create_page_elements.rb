class CreatePageElements < ActiveRecord::Migration
  def self.up
    create_table PageElement.table_name do |t|
      t.integer :page_id, :element_id, :position
      t.timestamps
    end
    add_column Element.table_name, :created_at, :datetime
    add_column Element.table_name, :updated_at, :datetime
    remove_column Element.table_name, :question_sheet_id
    Element.all.each do |e|
      e.update_attributes({:created_at => Time.now, :updated_at => Time.now})
      PageElement.create(:element_id => e.id, :page_id => e.page_id, :position => e.position, :updated_at => e.updated_at, :created_at => e.created_at)
    end
    remove_column Element.table_name, :page_id
  end

  def self.down
    remove_column Element.table_name, :created_at
    remove_column Element.table_name, :updated_at
    add_column Element.table_name, :question_sheet_id, :integer
    add_column Element.table_name, :page_id, :integer
    drop_table :page_elements
  end
end