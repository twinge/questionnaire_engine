module Qe
  class Admin::QuestionPagesController < ::ApplicationController
    
    before_filter :detect_question_sheet

    # GET /admin/question_pages/1
    # GET /admin/question_pages/1.json
    def show
      @page = @question_sheet.pages.find(params[:id])
      @elements = @page.elements

      respond_to do |format|
        format.js
        format.json { render json: @elements }
      end
    end

    # GET /admin/question_pages/1/edit
    # GET /admin/question_pages/1/edit.js
    def edit
      @page = @question_sheet.pages.find(params[:id])
      
      respond_to do |format|
        format.js
        format.json { render json: @page }
      end
    end

    
    # POST /admin/question_pages
    def create
      @page = @question_sheet.pages.build(:label => next_label, :number => @question_sheet.pages.length + 1)
      @all_pages = @question_sheet.pages.find(:all)

      respond_to do |format|
        if @page.save
          format.js
          format.json { render json: 'success' }
        else
          format.js { render :action => "error.rjs"}
          format.json { render json: 'failture' }
        end
      end
    end

    
    # PUT /admin/quesiton_pages/1
    # PUT /admin/quesiton_pages/1.json
    def update
      @page = @question_sheet.pages.find(params[:id])

      respond_to do |format|
        if @page.update_attributes(params[:page], :without_protection => true)
          format.js
          format.json { render json: 'success' } 
        else
          format.js { render :action => "error.rjs"}
          format.json { render json: 'failture' }
        end
      end
    end

    
    # DELETE /admin/question_pages/1
    # DELETE /admin/question_pages/1.json
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

    # # Load panel using AJAX functionality.
    # # GET /pages/:id/show_panel
    # def show_panel
    #   @tab_name = params[:panel_name]
    #   @panel_name = params[:panel_name] == "properties" ? "prop_sheet" : params[:panel_name]
    #   @all_pages = @question_sheet.pages.find(:all)  # for pages_list
    #   @page = @question_sheet.pages.find(params[:id])
      
    #   respond_to do |format|
    #     format.js # load panel
    #   end
    # end

    # # Reorders pages so according to 
    # # POST /pages/reorder
    # def reorder 
    #   @question_sheet.pages.each do |page|
    #     if params['list-pages'].index(page.id.to_s)
    #       page.number = params['list-pages'].index(page.id.to_s) + 1
    #       page.save!(:validate => false)
    #       @page = page
    #     end
    #   end
    #   render :nothing => true
    # end

    private
    def detect_question_sheet
      @question_sheet = Qe::QuestionSheet.find(params[:question_sheet_id])
    end

    # next unused label with "Untitled form" prefix
    def next_label
      Qe::ModelExtensions.next_label("Page", untitled_labels)
    end

    # returns a list of existing Untitled forms
    # (having a separate method makes it easy to mock in the spec)
    def untitled_labels
      Qe::Page.find(:all, :conditions => %{label like 'Page%'}).map {|s| s.label}
    end


  end
end