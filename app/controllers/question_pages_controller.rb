class QuestionPagesController < ApplicationController
  unloadable
  before_filter :check_valid_user
  layout 'admin'
  
  before_filter :get_sheet
  
  # selecting a page
  # GET /pages/1
  def show
    @page = @question_sheet.pages.find(params[:id])
    @elements = @page.elements

    respond_to do |format|
      format.js
    end
  end

  # GET /pages/1/edit
  def edit
    @page = @question_sheet.pages.find(params[:id])
    
    respond_to do |format|
      format.js
    end
  end

  # POST /pages
  def create
    @page = @question_sheet.pages.build(:label => next_label, :number => @question_sheet.pages.length + 1)
    @all_pages = @question_sheet.pages.find(:all)

    respond_to do |format|
      if @page.save
        format.js
      else
        format.js { render :action => "error.rjs"}
      end
    end
  end

  # PUT /pages/1
  def update
    @page = @question_sheet.pages.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.js
      else
        format.js { render :action => "error.rjs"}
      end
    end
  end

  # DELETE /pages/1
  def destroy
    unless @question_sheet.pages.length <= 1
      @page = @question_sheet.pages.find(params[:id])
      @page.destroy

      @all_pages = @question_sheet.pages.find(:all)
      @page = @all_pages[0]
  
      respond_to do |format|
        format.js
      end
    end
  end
  
  # load panel all AJAX-like
  # GET
  def show_panel
    @tab_name = params[:panel_name]
    @panel_name = params[:panel_name] == "properties" ? "prop_sheet" : params[:panel_name]
    @all_pages = @question_sheet.pages.find(:all)  # for pages_list
    @page = @question_sheet.pages.find(params[:id])
    
    respond_to do |format|
      format.js # load panel
    end
  end
  
  private
  def get_sheet
    @question_sheet = QuestionSheet.find(params[:question_sheet_id])
  end
  
  # next unused label with "Untitled form" prefix
  def next_label
    ModelExtensions.next_label("Page", untitled_labels)
  end

  # returns a list of existing Untitled forms
  # (having a separate method makes it easy to mock in the spec)
  def untitled_labels
    Page.find(:all, :conditions => %{label like 'Page%'}).map {|s| s.label}
  end
end
