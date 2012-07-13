class Region < ActiveRecord::Base
  unloadable
  set_table_name "ministry_regionalteam"
  set_primary_key "teamID"

  attr_reader :standard_region_codes
  @@standard_region_codes = ["NE", "MA", "MS", "SE", "GL", "UM", "GP", "RR", "NW", "SW"]
  
  def self.standard_regions
    find(:all, :conditions => [ "region IN (?)", @@standard_region_codes])
  end
  
  def sp_phone
    @sp_phone ||= spPhone.blank? ? phone : spPhone
  end
end
