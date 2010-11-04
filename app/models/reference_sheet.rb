class ReferenceSheet < AnswerSheet
  include Rails.application.routes.url_helpers
  set_table_name "#{Questionnaire.table_name_prefix}references"
  set_inheritance_column 'fake'
  
  belongs_to :question, :class_name => 'Element', :foreign_key => 'question_id'
  belongs_to :applicant_answer_sheet, :class_name => Questionnaire.answer_sheet_class, :foreign_key => "applicant_answer_sheet_id"
  before_create :generate_access_key
  
  validates_presence_of :first_name, :last_name, :phone, :email, :relationship, :on => :update, :message => "can't be blank"
  
  delegate :style, :to => :question

  before_save :check_email_change
  
  acts_as_state_machine :initial => :created, :column => :status

  state :started
  state :created
  state :completed, :enter => Proc.new {|ref|
                                ref.submitted_at = Time.now
                                # SpReferenceMailer.deliver_completed(ref)
                                # SpReferenceMailer.deliver_completed_confirmation(ref)
                                ref.applicant_answer_sheet.complete(ref)
                              }

  event :start do
    transitions :to => :started, :from => :created
  end

  event :submit do
    transitions :to => :completed, :from => :started
  end
  
  alias_method :applicant, :applicant_answer_sheet
  def generate_access_key
    self.access_key = Digest::MD5.hexdigest((object_id + Time.now.to_i).to_s)
  end
  
  def email_sent?() !self.email_sent_at.nil? end
  
  # send email invite
  def send_invite    
    return if self.email.blank?   # bypass blanks for now
    
    application = self.applicant_answer_sheet
    
    Notifier.deliver_notification(self.email,
                                  Questionnaire.from_email, 
                                  "Reference Invite", 
                                  {'reference_full_name' => self.name, 
                                   'applicant_full_name' => application.name,
                                   'applicant_email' => application.email, 
                                   'applicant_home_phone' => application.phone, 
                                   'reference_url' => edit_reference_sheet_url(self, :a => self.access_key, :host => ActionMailer::Base.default_url_options[:host])})
    # Send notification to applicant
    Notifier.deliver_notification(applicant_answer_sheet.email, # RECIPIENTS
                                  Questionnaire.from_email, # FROM
                                  "Reference Notification to Applicant", # LIQUID TEMPLATE NAME
                                  {'applicant_full_name' => applicant_answer_sheet.name,
                                   'reference_full_name' => self.name,
                                   'reference_email' => self.email,
                                   'application_url' => edit_answer_sheet_url(applicant_answer_sheet, :host => ActionMailer::Base.default_url_options[:host])})

    self.email_sent_at = Time.now
    self.save(:validate => false)
    
    true
  end
  
  def name
    [first_name, last_name].join(' ')
  end
  
  def reference
    self
  end
  
  def to_s
    name
  end
  
  def required?
    question.required?(applicant_answer_sheet)
  end
  
  def reference?
    true  
  end
  
  protected
    # if the email address has changed, we have to trash the old reference answers
    def check_email_change
      if changed.include?('email')
        answers.destroy
      end
    end
end

