# == Schema Information
# Schema version: 17
#
# Table name: sitrack_tracking
#
#  id                   :integer(10)   not null, primary key
#  application_id       :integer(10)   
#  person_id            :integer(10)   
#  status               :string(20)    
#  internType           :string(20)    
#  tenure               :string(50)    
#  ssn                  :string(50)    
#  teamLeader           :integer(3)    
#  caringRegion         :string(50)    
#  passportNo           :string(20)    
#  asgYear              :string(9)     
#  asgTeam              :string(50)    
#  asgCity              :string(50)    
#  asgState             :string(50)    
#  asgCountry           :string(50)    
#  asgContinent         :string(50)    
#  asgSchool            :string(90)    
#  spouseName           :string(50)    
#  departureDate        :datetime      
#  terminationDate      :datetime      
#  notes                :text          
#  changedByPerson      :integer(10)   
#  appReadyDate         :datetime      
#  evaluator            :string(50)    
#  evalStartDate        :datetime      
#  preADate             :datetime      
#  medPsychDate         :datetime      
#  finalADate           :datetime      
#  placementComments    :text          
#  expectReturnDate     :datetime      
#  confirmReturnDate    :datetime      
#  maidenName           :string(50)    
#  sendLane             :string(20)    
#  mpdEmailSent         :datetime      
#  kickoffNotes         :text          
#  addFormSent          :datetime      
#  updateFormSent       :datetime      
#  picture              :string(255)   
#  fieldCoach           :string(50)    
#  medPsychSent         :datetime      
#  needsDebtCheck       :integer(3)    
#  acceptanceLetter     :datetime      
#  evalDocsRec          :datetime      
#  oneCard              :integer(3)    
#  playbookSent         :datetime      
#  kickoffRoomate       :string(50)    
#  futurePlan           :string(50)    
#  mpReceived           :datetime      
#  physicalSent         :datetime      
#  physicalReceived     :datetime      
#  evalType             :string(10)    
#  preIKWSent           :datetime      
#  debt                 :string(50)    
#  restint              :text          
#  evalSummary          :datetime      
#  returnDate           :datetime      
#  effectiveChange      :datetime      
#  addForm              :datetime      
#  salaryForm           :datetime      
#  acosForm             :datetime      
#  joinStaffForm        :datetime      
#  readyDate            :datetime      
#  additionalSalaryForm :datetime      
#  miniPref             :string(50)    
#  birthCity            :string(50)    
#  birthState           :string(50)    
#  ikw_location         :string(100)   
#  summer_preference    :string(100)   
#  summer_assignment    :string(100)   
#

class SitrackTracking < ActiveRecord::Base
  set_table_name            "sitrack_tracking"
  belongs_to                :hr_si_application, :foreign_key => 'application_id'
  
  def is_stint?
    return true if ['ICS','STINT'].include?(internType)
    return false
  end
end
