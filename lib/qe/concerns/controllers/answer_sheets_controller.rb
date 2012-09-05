# require 'active_support/conern'

module Qe::Concerns::Controllers::AnswerSheetsController
  extend ActiveSupport::Concern

  included do
    unloadable
    layout 'qe/application'
    helper 'qe/answer_pages'
    before_filter :get_answer_sheet, :only => [:edit, :show, :send_reference_invite, :submit]
  end

  # List existing answer sheets.
  def index
    @answer_sheets = answer_sheet_type.find(:all, :order => 'created_at')

    # drop down of sheets to capture data for
    @question_sheets = Qe::QuestionSheet.find(:all, :order => 'label').map {|s| [s.label, s.id]}
  end
  
  # Create AnswerSheet for given QuestionSheet.
  # POST /answer_sheets?question_sheet_id=
  def create
    @question_sheet = Qe::QuestionSheet.find(params[:question_sheet_id])
    @answer_sheet = @question_sheet.answer_sheets.create
    
    redirect_to edit_answer_sheet_path(@answer_sheet)
  end
  
  # Display answer sheet for data capture (page 1)
  def edit
    @presenter = Qe::AnswerPagesPresenter.new(self, @answer_sheet, params[:a])
    unless @presenter.active_answer_sheet.pages.present?
      flash[:error] = "Sorry, there are no questions for this form yet."
      if request.env["HTTP_REFERER"]
        redirect_to :back
      else
        render "this is cool"
        # render :text => "", :layout => true
      end
    else
      @elements = @presenter.questions_for_page(:first).elements
      @page = @presenter.pages.first
    end
  end
  
  # Display captured answers (read-only)
  def show
    # TODO fix this association. AnswerSheet and QuestionSheet are related via a has_many_and_belongs_to_many
    # either filtering needs to happen here, or the relationship needs to be changed
    @question_sheet = @answer_sheet.question_sheet

    pf = Qe.table_name_prefix
    @elements = @question_sheet.pages.collect {|p| p.elements.includes(:pages).order("#{pf}pages.number,#{pf}page_elements.position").all}.flatten
    @elements = Qe::QuestionSet.new(@elements, @answer_sheet).elements.group_by{ |e| e.pages.first }
  end
  
  # Sends email inviting receipent review user.
  def send_reference_invite
    @reference = @answer_sheet.reference_sheets.find(params[:reference_id])
    @reference.update_attributes!(params[:reference][@reference.id.to_s])
    if @reference.valid?
      @reference.send_invite
    end
  end
  
  # Submit AnswerSheet. Cannot reverse this action.
  def submit
    return false unless validate_sheet
    flash[:notice] = "Your form has been submitted. Thanks!"
    redirect_to  main_app.root_path
  end
  
  protected
  
  def answer_sheet_type
    (params[:answer_sheet_type] || Qe.answer_sheet_class || 'Qe::AnswerSheet').constantize
  end
  
  # Sets ````@answer_sheet```` for this controller class.
  def get_answer_sheet
    @answer_sheet = answer_sheet_type.find(params[:id])
  end
  
  def validate_sheet
    unless @answer_sheet.completely_filled_out?
      @presenter = Qe::AnswerPagesPresenter.new(self, @answer_sheet, params[:a])
      render 'incomplete'
      return false
    end
    return true
  end
end
