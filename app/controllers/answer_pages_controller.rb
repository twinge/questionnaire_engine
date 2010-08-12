require_dependency 'answer_pages_presenter'
class AnswerPagesController < ApplicationController
  before_filter :get_answer_sheets, :only => [:edit, :update, :save_file, :index]
  unloadable
  
  def edit
    @elements = @presenter.questions_for_page(params[:id]).elements
    @page = Page.find(params[:id]) || Page.find_by_number(1)
    
    render :partial => 'answer_page', :locals => { :show_first => nil }
  end

  # validate and save captured data for a given page
  # PUT /answer_sheets/1/pages/1
  def update
    questions = @presenter.questions_for_page(params[:id])
    questions.post(params[:answers])
    
    #if questions.valid? then
    
    questions.save
    
    @elements = questions.elements
    
    respond_to do |format|
      format.js { head :ok }
      #format.html
    end
  end
  
  def save_file
    if params[:answers]
      @page = Page.find(params[:id])
      @presenter.active_page = @page
      question = Element.find(params[:question_id])
      answer = Answer.find(:first, :conditions => {:answer_sheet_id => @answer_sheet.id, :question_id => question.id})
      question.answers = [answer] if answer

      answer = question.save_file(@answer_sheet, params[:answers][question.id.to_s])[0]
      
      responds_to_parent do
        render :update do |page|
          page[@presenter.active_page.dom_id + '-spinner'].hide
          page[@presenter.active_page.dom_id + '-attachment'].replace_html "Current File: " + link_to(answer.filename, answer.public_filename)
          page[@presenter.active_page.dom_id + '-attachment'].highlight
        end
      end
    else
      respond_to do |format|
        format.js { head :ok }
      end
    end
  end
  
  protected
  
  def get_answer_sheets
    @answer_sheets = AnswerSheet.find(params[:answer_sheet_id])
    @presenter = AnswerPagesPresenter.new(self, @answer_sheets)
  end

end
