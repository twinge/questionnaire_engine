class ReferenceSheetsController < AnswerSheetsController
  skip_before_filter :ssm_login_required, :login
  before_filter :edit_only, :except => [:edit]
  def edit
    @answer_sheet = @reference_sheet = ReferenceSheet.find_by_id_and_access_key(params[:id], params[:a])
    unless @answer_sheet
      render :not_found and return
    end
    @answer_sheet.start!
    # Set up question_sheet if needed
    if @answer_sheet.question_sheets.empty?
      @answer_sheet.question_sheets << QuestionSheet.find(@answer_sheet.question.related_question_sheet)
    end
    @presenter = AnswerPagesPresenter.new(self, @answer_sheet, params[:a])
    @elements = @presenter.questions_for_page(:first).elements
    @page = @presenter.pages.first
    render 'answer_sheets/edit'
  end
  
  protected
    def get_answer_sheet
      @answer_sheet ||= ReferenceSheet.find(params[:id])
      return false unless @answer_sheet
    end
    
    def edit_only
      return false
    end
end
