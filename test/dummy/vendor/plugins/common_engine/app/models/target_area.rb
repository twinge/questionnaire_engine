class TargetArea < ActiveRecord::Base
  unloadable
  
  set_table_name				"ministry_TargetArea"
  set_primary_key   			"targetAreaID"
  
  #override the inheritance column
  self.inheritance_column = "nothing"
  
  has_many :ministry_activities, :foreign_key => "fk_targetAreaID"
  
  def active
    @active = false
    ministry_activities.each do |activity|
      if !TargetArea.inactive_statuses.include?(activity.status)
        @active = true
        break;
      end
    end
    @active
  end
  
  def self.inactive_statuses
    ['IN']
  end

end
