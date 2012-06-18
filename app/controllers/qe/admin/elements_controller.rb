module Qe
  class Admin::ElementsController < ApplicationController
    unloadable
    before_filter :check_valid_user
    layout 'qe.admin'
    
    before_filter :get_page
    
    # GET /elements/1
    def show
      @element = QeElement.find(params[:id])

      respond_to do |format|
        format.js
      end
    end

    # GET /element/1/edit
    def edit
      @element = QeElement.find(params[:id])
      
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
      @questions = params[:element_type].constantize.active.order('label')
      params[:element] ||= {}
      if params[:element][:style]
        @questions = @questions.where(:style => params[:element][:style]).all.uniq
      end
    end
    
    def use_existing
      @element = QeElement.find(params[:id])
      # Don't put the same question on a questionnaire twice
      unless @page.question_sheet.elements.include?(@element)
        @page_element = QePageElement.create(:element => @element, :page => @page)
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
          @page_element = QePageElement.create(:element => @element, :page => @page)
          format.js
        else
          format.js { render :action => 'error.rjs' }
        end
      end
    end

    # PUT /elements/1
    def update
      @element = QeElement.find(params[:id])

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
      @element = QeElement.find(params[:id])
      # Start by removing the element from the page
      page_element = QePageElement.where(:element_id => @element.id, :page_id => @page.id).first
      page_element.destroy if page_element
      
      # If this element is not on any other pages, is not a question or has no answers, Destroy it
      if @element.reuseable? && (QePageElement.where(:element_id => params[:id]).present? || @element.has_response?)
        @element.update_attributes(:question_grid_id => nil, :conditional_id => nil)
      else
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
          grid_id = key.sub('questions_list_', '').to_i
          # See if we're ordering inside of a grid
          if grid_id > 0
            QeElement.find(grid_id).elements.each do |element|
              if index = params[key].index(element.id.to_s)
                element.position = index + 1 
                element.save(:validate => false)
              end
            end
          else
            @page.page_elements.each do |page_element|
              if index = params[key].index(page_element.element_id.to_s)
                page_element.position = index + 1 
                page_element.save(:validate => false)
                @element = page_element.element
              end
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
      # Remove page element for this page since it's now in a grid
      QePageElement.where(:page_id => @page.id, :element_id => element.id).first.try(:destroy)
    end
    
    def remove_from_grid
      element = QeElement.find(params[:id])
      QePageElement.create(:element_id => element.id, :page_id => @page.id) unless QePageElement.where(:element_id => element.id, :page_id => @page.id).first
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
      element = QeElement.find(params[:id])
      @element = element.duplicate(@page, element.question_grid || element.choice_field)
      respond_to do |format|
        format.js 
      end
    end
    
    private
    def get_page
      @page = QePage.find(params[:page_id])
    end
    
  end
end
