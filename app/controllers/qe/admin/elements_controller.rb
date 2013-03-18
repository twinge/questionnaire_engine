module Qe
  module Admin 
    class ElementsController < ::ApplicationController
    
      module M
        extend ActiveSupport::Concern
        included do 
          before_filter :get_page
        end
        
        # Edit the element.
        # GET /element/1/edit
        def edit
          @element = Qe::Element.find(params[:id])
          
          # for dependencies
          if @element.question?
            (3 - @element.conditions.length).times { @element.conditions.build }
            @questions_before_this = @page.questions_before_position(@element.position(@page)) 
          end
          
          respond_to do |format|
            format.js
          end
        end

        # Instantiate a new element (not saved to the database).
        # GET /elements/new
        def new
          @questions = "Qe::#{params[:element_type]}".constantize.active.order('label')
          params[:element] ||= {}
          if params[:element][:style]
            @questions = @questions.where(:style => params[:element][:style]).all.uniq
          end
        end

        # Ensures questionnaire does not contain the same question.
        def use_existing
          @element = Qe::Element.find(params[:id])
          # Don't put the same question on a questionnaire twice
          unless @page.question_sheet.elements.include?(@element)
            @page_element = Qe::PageElement.create(:element => @element, :page => @page)
          end
          @question_sheet = @page.question_sheet
          render :create
        end

        # Create a new element (saved to the database)
        # POST /elements
        def create
          @element = "Qe::#{params[:element_type]}".constantize.new(params[:element])
          @element.required = true if @element.question?
          @question_sheet = @page.question_sheet
          respond_to do |format|
            # TODO engineer the mass assignment flow of the engine
            if @element.save!(:without_protection => true)
              @page_element = Qe::PageElement.create(:element => @element, :page => @page)
              format.js
            else
              format.js { render :action => 'error.js.erb' }
            end
          end
        end

        # Update element
        # PUT /elements/1
        def update
          @element = Qe::Element.find(params[:id])

          respond_to do |format|
            if @element.update_attributes(params[:element])
              format.js
            else
              format.js { render :action => 'error.js.erb' }
            end
          end
        end

        # Delete an element.
        # Also deletes the corresponding Qe::PageElement object 
        # DELETE /elements/1
        def destroy
          @element = Qe::Element.find(params[:id])
          # Start by removing the element from the page
          page_element = Qe::PageElement.where(:element_id => @element.id, :page_id => @page.id).first
          page_element.destroy if page_element

          @element.destroy.inspect
          
          # If this element is not on any other pages, is not a question or has no answers, Destroy it
          if @element.reuseable? && (Qe::PageElement.where(:element_id => params[:id]).present? || @element.has_response?)
            @element.update_attributes(:question_grid_id => nil, :conditional_id => nil)
          else
            @element.destroy
          end

          respond_to do |format|
            format.js
          end
        end

        # TODO describe method
        def reorder 
          # since we don't know the name of the list, just find the first param that is an array
          params.each_key do |key| 
            if key.include?('questions_list')
              grid_id = key.sub('questions_list_', '').to_i
              # See if we're ordering inside of a grid
              if grid_id > 0
                Qe::Element.find(grid_id).elements.each do |element|
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

        # TODO describe the method
        def drop
          element = Qe::Element.find(params[:draggable_element].split('_')[1])  # element being dropped
          target  = Qe::Element.find(params[:id])
          
          # TODO might need to revise due to namespacing
          case target.class.to_s
                                when 'Qe::QuestionGrid', 'Qe::QuestionGridWithTotal'
                                  # abort if the element is already in this box
                                  if element.question_grid_id == params[:id].to_i
                                    render :nothing => true
                                  else
                                    element.question_grid_id = params[:id]
                                    element.save!
                                  end
                                when 'Qe::ChoiceField'
                                  # abort if the element is already in this box
                                  if element.conditional_id == params[:id].to_i
                                    render :nothing => true
                                  else
                                    element.conditional_id = params[:id]
                                    element.save!
                                  end
          end
          # Remove page element for this page since it's now in a grid
          Qe::PageElement.where(:page_id => @page.id, :element_id => element.id).first.try(:destroy)
        end

        # TODO describe method
        def remove_from_grid
          element = Qe::Element.find(params[:id])
          Qe::PageElement.create(:element_id => element.id, :page_id => @page.id) unless Qe::PageElement.where(:element_id => element.id, :page_id => @page.id).first
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

        # Duplicates the element; handles logic for nested elements.
        # POST qe/admin/elements
        def duplicate
          element = Qe::Element.find(params[:id])

          # this may not be a good idea. works in controller specs,
          # might need to change this later.
          if element.question_grid_id 
            @element = element.duplicate(@page, element.question_grid)
          elsif element.conditional_id
            @element = element.duplicate(@page, element.choice_field_id)
          else
            @element = element.duplicate(@page)
          end

          respond_to do |format|
            format.js 
          end
        end

        private
        def get_page
          @page = Qe::Page.find(params[:page_id])
        end
      end

      include Qe::Admin::BaseControllerConfigs
      include Qe::Admin::ElementsController::M
    end
  end
end
