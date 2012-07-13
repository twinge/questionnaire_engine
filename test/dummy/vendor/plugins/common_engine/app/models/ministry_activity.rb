class MinistryActivity < ActiveRecord::Base
  unloadable
  set_table_name			"ministry_activity"
  set_primary_key   			"ActivityID"
  belongs_to :target_area, :foreign_key => "fk_targetAreaID"
  belongs_to :ministry_local_level, :foreign_key => "fk_teamID"
  
end
