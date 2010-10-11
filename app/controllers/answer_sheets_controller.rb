class AnswerSheetsController < ApplicationController
  unloadable
  layout 'application'
  helper :answer_pages
  
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
    @answer_sheet = answer_sheet_type.find(params[:id])
    @presenter = AnswerPagesPresenter.new(self, @answer_sheet)
    @elements = @presenter.questions_for_page(:first).elements
    @page = Page.find_by_number(1)
  end
  
  # display captured answers (read-only)
  def show
    @answer_sheet = answer_sheet_type.find(params[:id])
    @question_sheet = @answer_sheet.question_sheet
    @elements = @question_sheet.pages.collect {|p| p.elements.includs(:page).order('pages.number,page_elements.position').all}.flatten
    @elements = QuestionSet.new(@elements, @answer_sheet).elements.group_by(&:page_id)
  end
  
  protected 
    def answer_sheet_type
      (params[:answer_sheet_type] || 'AnswerSheet').constantize
    end
end
