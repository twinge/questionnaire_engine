class HrSiProject < ActiveRecord::Base
  unloadable
  set_table_name				"hr_si_project"
	set_primary_key 			"SIProjectID"
  
  validates_presence_of :name, :city, :country
  
  def validate
    self.errors.add_to_base("Please select a Location Type") if projectType.blank?
    self.errors.add_to_base("Student Start Date can't be blank") if studentStartDate.blank?
    self.errors.add_to_base("Student End Date can't be blank") if studentEndDate.blank?
    self.errors.add_to_base("Display Location can't be blank") if displayLocation.blank?
    self.errors.add_to_base("Sending Region can't be blank") if partnershipRegion.blank?
    if (!studentStartDate.blank? && !studentEndDate.blank?) 
      self.errors.add_to_base("Student Start Date must be before Student End Date") unless studentStartDate < studentEndDate
    end
  end
  
  def self.find_all_available(locations="", region=nil, show_all=false, person=nil, projectType="n")
    conditions = ""
    gender = person.gender? ? "Male" : "Female" unless person.nil?
    
    # include selected locations
    conditions += "(SIProjectID in (#{locations})) OR " unless locations.blank?

    # check dates
    today = DateTime.now
    conditions += "(studentStartDate > \'#{today}\') "
    conditions += "AND (studentStartDate is not null) "
    conditions += "AND (studentEndDate > studentStartDate) "
    conditions += "AND (siYear = '#{HrSiApplication::YEAR}') "
        
    # is the project on hold?
    conditions += "AND ((onHold <> \'1\') or (onHold is null)) "
    
    # is the project of the desired type (and in the desired region)?
    conditions += "AND ((projectType = '#{projectType}') "
    if (!region.blank?)
      conditions += "OR (partnershipRegion = '#{region}') "
      if (show_all)
        conditions += "OR ((partnershipRegionOnly <> '1') OR (partnershipRegionOnly is null)) "
      end
    end
    conditions += ")"
    
    # are there available applicant spots?
    
    # are there available applicant spots for the person's gender?
    
    # are there available participant spots?
    
    # are there available participant spots for the person's gender?
    
    self.find(:all, :conditions => conditions, :order => "name ASC")
  end
end
