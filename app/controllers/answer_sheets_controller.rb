class AnswerSheetsController < ApplicationController
  unloadable
  layout 'application'
  helper :answer_pages
  before_filter :get_answer_sheet, :only => [:edit, :show, :send_reference_invite]
  # list existing answer sheets
  def index
    
    @answer_sheets = answer_sheet_type.find(:all, :order => 'created_at')
    
    # drop down of sheets to capture data for
    @question_sheets = QuestionSheet.find(:all, :order => 'label').map {|s| [s.label, s.id]}
  end
  
  def create
    @question_sheet = QuestionSheet.find(params[:question_sheet_id])
    @answer_sheet = @question_sheet.answer_sheets.create
    
    redirect_to edit_answer_sheet_path(@answer_sheet)
  end
  
  # display answer sheet for data capture (page 1)
  # GET /answer_sheets/1;edit
  def edit
    @presenter = AnswerPagesPresenter.new(self, @answer_sheet)
    @elements = @presenter.questions_for_page(:first).elements
    @page = Page.find_by_number(1)
  end
  
  # display captured answers (read-only)
  def show
    @question_sheet = @answer_sheet.question_sheet
    @elements = @question_sheet.pages.collect {|p| p.elements.includs(:page).order('pages.number,page_elements.position').all}.flatten
    @elements = QuestionSet.new(@elements, @answer_sheet).elements.group_by(&:page_id)
  end
  
  def send_reference_invite
    @reference = @answer_sheet.reference_sheets.find(params[:reference_id])
      # Send invite to reference
    if @reference.send_invite

      # Send notification to applicant
      Notifier.deliver_notification(@answer_sheet.email, # RECIPIENTS
                                    Questionnaire.from_email, # FROM
                                    "Reference Notification to Applicant", # LIQUID TEMPLATE NAME
                                    {'applicant_full_name' => @answer_sheet.name,
                                     'reference_full_name' => @reference.name,
                                     'reference_email' => @reference.email,
                                     'application_url' => edit_answer_sheet_url(@answer_sheet)})

      @reference.email_sent_at = Time.now
      @reference.save
    end
  end
  
  protected 
    def answer_sheet_type
      (params[:answer_sheet_type] || Questionnaire.answer_sheet_class || 'AnswerSheet').constantize
    end
    
    def get_answer_sheet
      @answer_sheet = answer_sheet_type.find(params[:id])
    end
end
