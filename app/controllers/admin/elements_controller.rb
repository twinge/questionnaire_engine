class Admin::ElementsController < ApplicationController
  unloadable
  before_filter :check_valid_user
  layout 'qe.admin'
  
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
      @questions_before_this = @page.questions_before_position(@element.position(@page)) 
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def new
    @questions = params[:element_type].constantize.order('label')
    params[:element] ||= {}
    if params[:element][:style]
      @questions = @questions.where(:style => params[:element][:style])
    end
  end
  
  def use_existing
    @element = Element.find(params[:id])
    # Don't put the same question on a questionnaire twice
    unless @page.question_sheet.elements.include?(@element)
      @page_element = PageElement.create(:element => @element, :page => @page)
    end
    @question_sheet = @page.question_sheet
    render :create
  end

  # POST /elements
  def create
    @element = params[:element_type].constantize.new(params[:element])
    @element.required = true if @element.question?
    @question_sheet = @page.question_sheet
    respond_to do |format|
      if @element.save!
        @page_element = PageElement.create(:element => @element, :page => @page)
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
    # Start by removing the element from the page
    page_element = PageElement.find(:element_id => params[:id], :page_id => @page.id)
    page_element.destroy if page_element
    
    # If this element is not a question or has no answers, Destroy it
    @element = @page.elements.find(params[:id])
    unless @element.has_response?
      @element.destroy
    end

    respond_to do |format|
      format.js 
    end
  end
  
  def reorder 
    # since we don't know the name of the list, just find the first param that is an array
    params.each_key do |key| 
      if key.include?('questions_list')
        @page.page_elements.each do |page_element|
          if index = params[key].index(page_element.element_id.to_s)
            page_element.position = index + 1 
            page_element.save!
            @element = page_element.element
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
    target = Element.find(params[:id])
    case target.class.to_s
    when 'QuestionGrid', 'QuestionGridWithTotal'
      # abort if the element is already in this box
      if element.question_grid_id == params[:id].to_i
        render :nothing => true
      else
        element.question_grid_id = params[:id]
        element.save!
      end
    when 'ChoiceField'
      # abort if the element is already in this box
      if element.conditional_id == params[:id].to_i
        render :nothing => true
      else
        element.conditional_id = params[:id]
        element.save!
      end
    end
  end
  
  def remove_from_grid
    element = Element.find(params[:id])
    if element.question_grid_id
      element.set_position(element.question_grid.position(@page), @page) 
      element.question_grid_id = nil
    elsif element.conditional_id
      element.set_position(element.choice_field.position(@page), @page) 
      element.conditional_id = nil
    end
    element.save!
    render :action => :drop
  end
  
  def duplicate
    element = Element.find(params[:id])
    @element = element.duplicate(@page)
    respond_to do |format|
      format.js {render :action => :create}
    end
  end
  
  private
  def get_page
    @page = Page.find(params[:page_id])
  end
  
end