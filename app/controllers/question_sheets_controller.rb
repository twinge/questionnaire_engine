# QuestionSheets is used exclusively on the administration side to design a Questionniare
#  which can than be instantiated as an AnswerSheet for data capture on the front-end

class QuestionSheetsController < ApplicationController
  before_filter :check_valid_user
  layout 'admin'
 
  # list of all questionnaires/forms to edit
  # GET /question_sheets
  def index
    @question_sheets = QuestionSheet.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @question_sheets.to_xml }
    end
  end

  # entry point: display form designer with page 1 and panels loaded
  # GET /question_sheets/1
  def show
    @question_sheet = QuestionSheet.find(params[:id])
    @all_pages = @question_sheet.pages.find(:all)
    @page = @all_pages[0]

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @question_sheet.to_xml }
    end
  end

  # create sheet with inital page, redirect to show
  # POST /question_sheets
  def create
    @question_sheet = QuestionSheet.new_with_page
    
    respond_to do |format|
      if @question_sheet.save
        format.html { redirect_to question_sheet_path(@question_sheet) }
        format.xml  { head :created, :location => question_sheet_path(@question_sheet) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @question_sheet.errors.to_xml }
      end
    end
  end


  # display sheet properties panel
  # GET /question_sheets/1/edit
  def edit
    @question_sheet = QuestionSheet.find(params[:id])
    
    respond_to do |format|
      format.js
    end
  end
  
  # save changes to properties panel (label, language)
  # PUT /question_sheets/1
  def update
    @question_sheet = QuestionSheet.find(params[:id])

    respond_to do |format|
      if @question_sheet.update_attributes(params[:question_sheet])
        format.html { redirect_to question_sheet_path(@question_sheet) }
        format.js 
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js { render :action => "error.rjs"}
        format.xml  { render :xml => @question_sheet.errors.to_xml }
      end
    end
  end

  # mark sheet as destroyed
  # DELETE /question_sheets/1
  def destroy
    @question_sheet = QuestionSheet.find(params[:id])
    
    # Ensure that no applications are currently using this questionnaire
    #   before destroying it

    respond_to do |format|
      unless SleeveSheet.find_all_by_question_sheet_id(@question_sheet.id).length > 0
        @question_sheet.destroy

        format.html { redirect_to question_sheets_path }
        format.xml  { head :ok }
      else
        flash.now[:error] = "<b>#{@question_sheet.label}</b> is still being used in at least one application.  It cannot be deleted."
        @question_sheets = QuestionSheet.find(:all)
        format.html { render :action => :index }     
      end
    end
  end
end
