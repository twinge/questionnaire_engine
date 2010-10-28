require_dependency 'answer_pages_presenter'
class AnswerPagesController < ApplicationController
  before_filter :get_answer_sheet, :only => [:edit, :update, :save_file, :index]
  unloadable
  
  def edit
    @elements = @presenter.questions_for_page(params[:id]).elements
    @page = Page.find(params[:id]) || Page.find_by_number(1)
    
    render :partial => 'answer_page', :locals => { :show_first => nil }
  end

  # validate and save captured data for a given page
  # PUT /answer_sheets/1/pages/1
  def update
    @page = Page.find(params[:id])
    questions = @presenter.all_questions_for_page(params[:id])
    questions.post(params[:answers], @answer_sheet)
    
    questions.save
    
    @elements = questions.elements
    
    # Save references
    if params[:reference].present?
      params[:reference].each do |id, values|
        ref = @answer_sheet.reference_sheets.find(id)
        ref.attributes = values
        ref.save(:validate => false)
      end
    end
    @presenter.active_page = nil
    @answer_sheet.touch
    respond_to do |format|
      format.js
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
  
  def get_answer_sheet
    @answer_sheet = answer_sheet_type.find(params[:answer_sheet_id])
    @presenter = AnswerPagesPresenter.new(self, @answer_sheet, params[:a])
  end

  def answer_sheet_type
    (params[:answer_sheet_type] || Questionnaire.answer_sheet_class || 'AnswerSheet').constantize
  end
end
