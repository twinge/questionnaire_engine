class HrSiApplication < ActiveRecord::Base
  unloadable
  set_table_name        "hr_si_applications"
  set_primary_key       "applicationID"
  
  belongs_to :apply
  belongs_to :person, :foreign_key => "fk_personID"
  has_one    :sitrack_tracking, :foreign_key => 'application_id'
  has_one    :sitrack_mpd, :foreign_key => 'application_id'
  has_many   :sitrack_salary_forms
  belongs_to :location_a, :foreign_key => "locationA", :class_name => "HrSiProject" 
  belongs_to :location_b, :foreign_key => "locationB", :class_name => "HrSiProject" 
  belongs_to :location_c, :foreign_key => "locationC", :class_name => "HrSiProject" 
  
  before_create :create_apply
  before_save :stamp
  
  YEAR = 2012
  APPLICATION_SLEEVE_SLUG = "stint_internship" # this is set when creating a new sleeve

  #set dateChanged and changedBy
  def stamp
    self.dateAppLastChanged = Time.now
  end

  def self.is_intern(type)
    return true if 'Internship' == type || 'Class B Intern' == type
    return false
  end

  def find_or_create_apply()
    if self.apply.nil?
      create_apply
    end
    self.apply
  end
  
protected
  def sleeve
    @@sleeve ||= Sleeve.find_by_slug(APPLICATION_SLEEVE_SLUG)
    if @@sleeve.nil?
      raise "No STINT/Internship questionnaire found to match slug '#{APPLICATION_SLEEVE_SLUG}'"
    end
    @@sleeve
  end

  def create_apply
    self.dateAppStarted = Time.now
    self.apply ||= Apply.create(:sleeve_id => self.sleeve.id, :applicant_id => self.person.personID)
  end
end
