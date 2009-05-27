class ElementsController < ApplicationController
  unloadable
  before_filter :check_valid_user
  layout 'admin'
  
  before_filter :get_page
  
  # GET /elements/1
  def show
    @element = Element.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  # GET /element/1/edit
  def edit
    @element = @page.elements.find(params[:id])
    
    # for dependencies
    if @element.question?
      (3 - @element.conditions.length).times { @element.conditions.build }
      @questions_before_this = @page.questions_before_position(@element.position) 
    end
    
    respond_to do |format|
      format.js
    end
  end

  # POST /elements
  def create
    @element = params[:element_type].constantize.new(params[:element])
    @element.question_sheet_id = @page.question_sheet_id
    @element.page_id = @page.id
    @element.required = true if @element.question?
    respond_to do |format|
      if @element.save!
        format.js
      else
        format.js { render :action => 'error.rjs' }
      end
    end
  end

  # PUT /elements/1
  def update
    @element = Element.find(params[:id])

    respond_to do |format|
      if @element.update_attributes(params[:element])
        format.js
      else
        format.js { render :action => 'error.rjs' }
      end
    end
  end

  # DELETE /elements/1
  # DELETE /elements/1.xml
  def destroy
    @element = @page.elements.find(params[:id])
    @element.destroy

    respond_to do |format|
      format.js 
    end
  end
  
  def reorder 
    # since we don't know the name of the list, just find the first param that is an array
    params.each_key do |key| 
      if key.include?('questions_list')
        @page.elements.each do |element|
          if params[key].index(element.id.to_s)
            element.position = params[key].index(element.id.to_s) + 1 
            element.save
            @element = element
          end
        end
      end
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def drop
    element = Element.find(params[:draggable_element].split('_')[1])  # element being dropped
    # abort if the element is already in this box
    if element.question_grid_id == params[:id].to_i
      render :nothing => true
    else
      element.question_grid_id = params[:id]
      element.save
    end
  end
  
  def remove_from_grid
    element = Element.find(params[:id])
    element.position = element.question_grid.position
    element.question_grid_id = nil
    element.save
    render :action => :drop
  end
  
  private
  def get_page
    @page = Page.find(params[:page_id])
  end
  
end
