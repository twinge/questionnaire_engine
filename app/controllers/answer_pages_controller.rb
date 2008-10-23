class AnswerPagesController < ApplicationController

  def edit
    @answer_sheet = AnswerSheet.find(params[:answer_sheet_id])
    @presenter = AnswerPagesPresenter.new(self, @answer_sheet)
    @elements = @presenter.questions_for_page(params[:id]).elements
    
    render :partial => 'answer_page', :locals => { :show_first => nil }
  end

  # validate and save captured data for a given page
  # PUT /answer_sheets/1/pages/1
  def update
    @answer_sheet = AnswerSheet.find(params[:answer_sheet_id])
    @presenter = AnswerPagesPresenter.new(self, @answer_sheet)
    questions = @presenter.questions_for_page(params[:id])
    questions.post(params[:answers])
    
    #if questions.valid? then
    
    questions.save
    
    @elements = questions.elements
    
    respond_to do |format|
      format.js { head :ok }
      format.html
    end
  end

end
