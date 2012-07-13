# a visitor applies to a sleeve (application)
class Apply < ActiveRecord::Base
  unloadable
  
  acts_as_state_machine :initial => :started, :column => :status
  set_table_name "#{TABLE_NAME_PREFIX}#{self.table_name}"
  
  # State machine stuff
  state :started
  state :submitted, :enter => Proc.new {|app|
                                logger.info("application #{app.id} submitted")
                                SiApplicationMailer.deliver_submitted(app)
                                app.submitted_at = Time.now
                              }

  state :completed, :enter => Proc.new {|app|
                                logger.info("application #{app.id} completed")
                                # app.completed_at = Time.now
                                SiApplicationMailer.deliver_completed(app)
                              }

  state :unsubmitted, :enter => Proc.new {|app|
                                # TODO: Do we need to send a notification here?
                              }

  state :withdrawn, :enter => Proc.new {|app|
                                logger.info("application #{app.id} withdrawn")
                                # TODO: Do we need to send a notification here?
                                app.withdrawn_at = Time.now
                              }

  state :accepted, :enter => Proc.new {|app|
                                logger.info("application #{app.id} accepted")
                                app.accepted_at = Time.now
                             }

  state :declined, :enter => Proc.new {|app|
                                logger.info("application #{app.id} declined")
                             }

  event :submit do
    transitions :to => :submitted, :from => :started
    transitions :to => :submitted, :from => :unsubmitted
    transitions :to => :submitted, :from => :withdrawn
  end

  event :withdraw do
    transitions :to => :withdrawn, :from => :started
    transitions :to => :withdrawn, :from => :submitted
    transitions :to => :withdrawn, :from => :completed
    transitions :to => :withdrawn, :from => :unsubmitted
    transitions :to => :withdrawn, :from => :declined
    transitions :to => :withdrawn, :from => :accepted
  end

  event :unsubmit do
    transitions :to => :unsubmitted, :from => :submitted
    transitions :to => :unsubmitted, :from => :withdrawn
  end

  event :complete do
    transitions :to => :completed, :from => :submitted
    transitions :to => :completed, :from => :unsubmitted
    transitions :to => :completed, :from => :started
    transitions :to => :completed, :from => :withdrawn
    transitions :to => :completed, :from => :declined
    transitions :to => :completed, :from => :accepted
  end

  event :accept do
    transitions :to => :accepted, :from => :completed
    transitions :to => :accepted, :from => :started
    transitions :to => :accepted, :from => :withdrawn
    transitions :to => :accepted, :from => :declined
    transitions :to => :accepted, :from => :submitted
  end

  event :decline do
    transitions :to => :declined, :from => :completed
    transitions :to => :declined, :from => :accepted
  end

  belongs_to :sleeve
  belongs_to :applicant, :class_name => "Person", :foreign_key => "applicant_id"
  has_many :apply_sheets, :include => :sleeve_sheet
  has_many :references
  has_one :staff_reference, :class_name => "Reference", :foreign_key => "apply_id", :conditions => "sleeve_sheet_id = 2"
  has_one :discipler_reference, :class_name => "Reference", :foreign_key => "apply_id", :conditions => "sleeve_sheet_id = 3"
  has_one :roommate_reference, :class_name => "Reference", :foreign_key => "apply_id", :conditions => "sleeve_sheet_id = 4"
  has_one :friend_reference, :class_name => "Reference", :foreign_key => "apply_id", :conditions => "sleeve_sheet_id = 5"
  has_many :payments
  has_one :hr_si_application
  
  named_scope :by_region, proc {|region, year| {:include => [:applicant, :references, [:hr_si_application => :sitrack_tracking], :payments],
                               :conditions => ["#{HrSiApplication.table_name}.siYear = ? and (concat_ws('','',#{Person.table_name}.region )= ? or #{SitrackTracking.table_name}.regionOfOrigin = ?)", year, region, region],
                               :order => "#{Person.table_name}.lastName, #{Person.table_name}.firstName"}}
  
  after_save :complete
  
  # The statuses that mean an application has NOT been submitted
  def self.unsubmitted_statuses
    %w(started unsubmitted)
  end

  # The statuses that mean an applicant is NOT ready to evaluate
  def self.not_ready_statuses
    %w(submitted)
  end

  # The statuses that mean an applicant is NOT going
  def self.not_going_statuses
    %w(withdrawn declined)
  end

  # The statuses that mean an applicant IS ready to evaluate
  def self.ready_statuses
    %w(completed)
  end

  # The statuses that mean an applicant's application is not completed, but still in progress
  def self.uncompleted_statuses
    %w(started submitted unsubmitted)
  end
  
  def self.post_ready_statuses
    %w(accepted affiliate alumni being_evaluated on_assignment placed re_applied terminated transfer pre_a follow_through)
  end
  
  def self.completed_statuses
    Apply.ready_statuses | Apply.post_ready_statuses | %w(declined)
  end

  def self.post_submitted_statuses
    Apply.completed_statuses | Apply.not_ready_statuses
  end
  
  def self.statuses
    Apply.unsubmitted_statuses | Apply.not_ready_statuses | Apply.ready_statuses | Apply.post_ready_statuses | Apply.not_going_statuses
  end

  def has_paid?
    self.payments.each do |payment|
      return true if payment.approved?
    end
    return false
  end

  def paid_at
    self.payments.each do |payment|
      return payment.updated_at if payment.approved?
    end
    return nil
  end
  
  def payment_status
    self.has_paid? ? "Approved" : "Not Paid"
  end
  
  def email_address
    applicant.current_address.email if applicant && applicant.current_address
  end

  def completed_references
    sr = Array.new()
    references.each do |r|
      sr << r if r.completed?
    end
    sr
  end
  
  def staff_reference
    get_reference("Staff")
  end
  
  def discipler_reference
    get_reference("Discipler")
  end
  
  def roommate_reference
    get_reference("Roommate")
  end

  def friend_reference
    get_reference("Friend Reference")
  end
  
  def get_reference(title)
    references.each do |r|
      return r if r.sleeve_sheet.title.downcase.include? title.downcase
    end
    return Reference.new()
  end
  
  def answer_sheets
    a_sheets = Array.new()
    apply_sheets.each do |s|
      a_sheets << s.answer_sheet
    end
    a_sheets
  end
  
  def reference_answer_sheets
    r_sheets = Array.new()
    self.apply_sheets.find(:all, :include => [:sleeve_sheet, :answer_sheet], :conditions => ["#{SleeveSheet.table_name}.assign_to = ?", 'reference']).each do |s|
      r_sheets << s.answer_sheet
    end
    r_sheets
  end
  
  def has_references?
    self.apply_sheets.detect { |as| as.sleeve_sheet.assign_to == 'reference'}
  end
  
  # The :frozen? method lets the QuestionnaireEngine know to not allow
  # the user to change the answer to a question.
  def frozen?
    !%w(started unsubmitted).include?(self.status)
  end

  def can_change_references?
    %w(started unsubmitted submitted).include?(self.status)
  end

  # create Applicant answer sheets for this application
  def find_or_create_applicant_answer_sheets
    answer_sheets = []
    
    transaction do  
      # existing answer sheets for this applicant
      apply_sheets = self.apply_sheets.find(:all, :include => :sleeve_sheet, :conditions => ["#{SleeveSheet.table_name}.assign_to = ?", 'applicant'])
  
      if self.sleeve.present?
        if apply_sheets.empty?
          # check the application sleeve to setup answer sheets
        
          sleeve_sheets = self.sleeve.sleeve_sheets.find(:all, :conditions => "assign_to = 'applicant'")
    
          sleeve_sheets.each do |sleeve_sheet|
            answer_sheet = sleeve_sheet.question_sheet.answer_sheets.create
            # tie the answer_sheet to this visitor and sleeve via apply_sheets
            self.apply_sheets.create(:sleeve_sheet => sleeve_sheet, :answer_sheet => answer_sheet)
            answer_sheets << answer_sheet
          end
        else
          # use what we have
          answer_sheets = apply_sheets.map {|a| a.answer_sheet}
        end
      end
    end
    
    answer_sheets
  end
  
  def find_or_create_reference_answer_sheet(sleeve_sheet, create_new_answer_sheet = false)
    answer_sheet = nil
    
    transaction do
      apply_sheet = self.apply_sheets.find_by_sleeve_sheet_id(sleeve_sheet)
      
      if apply_sheet.nil?
        answer_sheet = sleeve_sheet.question_sheet.answer_sheets.create
        self.apply_sheets.create(:sleeve_sheet => sleeve_sheet, :answer_sheet => answer_sheet)
      else
        if create_new_answer_sheet
          apply_sheet.answer_sheet = sleeve_sheet.question_sheet.answer_sheets.create
          apply_sheet.save
        end
        answer_sheet = apply_sheet.answer_sheet
      end
    end
    
    answer_sheet
  end
  
  # prepare "provide reference" page for editing (either new or existing data)
  def reference_sheets
    references = []
    
    # pre-defined template
    sleeve_sheets = self.sleeve.sleeve_sheets.find(:all, :conditions => ['assign_to = ?', 'reference'])   # templates
    
    # any data?
    data = self.references.find(:all).index_by(&:sleeve_sheet_id)
    
    sleeve_sheets.each do |ss|
      reference = data[ss.id] || self.references.build(:sleeve_sheet_id => ss.id)   # existing data or an empty record
      reference.title = ss.title  # reference title for easy access
      reference.save! if reference.id.nil? 
      references << reference
    end
    
    references
  end
  
  def complete
    return true if self.completed?
    return false unless self.submitted?
    return false unless self.has_paid?
    return false unless self.completed_references.length == self.sleeve.reference_sheets.length
    return self.complete!
  end

end
