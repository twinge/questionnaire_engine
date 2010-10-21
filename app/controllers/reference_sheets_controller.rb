class ReferenceSheetsController < AnswerSheetsController
  before_filter :edit_only, :except => [:edit]
  def edit
    @answer_sheet = ReferenceSheet.find_by_id_and_access_key(params[:id], params[:a])
    # Set up question_sheet if needed
    if @answer_sheet.question_sheets.empty?
      @answer_sheet.question_sheets << QuestionSheet.find(@answer_sheet.question.related_question_sheet)
    end
    super
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
