class SpStaff < ActiveRecord::Base
  unloadable
  set_inheritance_column 'fake_column'
  set_table_name 'sp_staff'
  belongs_to :person
  belongs_to :sp_project, :class_name => "SpProject", :foreign_key => "project_id"
end