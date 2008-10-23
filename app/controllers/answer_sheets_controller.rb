class AnswerSheetsController < ApplicationController
  layout 'application'
  helper :answer_pages
  
  # list existing answer sheets
  def index
    @answer_sheets = AnswerSheet.find(:all, :order => 'created_at')
    
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
    @answer_sheet = AnswerSheet.find(params[:id])
    @presenter = AnswerPagesPresenter.new(self, @answer_sheet)
    @elements = @presenter.questions_for_page(:first).elements
  end
  
  # display captured answers (read-only)
  def show
    @answer_sheet = AnswerSheet.find(params[:id])
    @question_sheet = @answer_sheet.question_sheet
    @elements = @question_sheet.elements.find(:all, :include => 'page', :order => 'pages.number,elements.position')
    @elements = QuestionSet.new(@elements, @answer_sheet).elements.group_by(&:page_id)
  end
end
