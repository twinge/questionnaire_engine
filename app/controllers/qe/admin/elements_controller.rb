module Qe
  module Admin
    class ElementsController < ::ApplicationController
    
      before_filter :detect_page

      def edit
        @element = Qe::Element.find(params[:id])
        
        respond_to do |format|
          format.js
        end      
      end
    
      def new
        @questions = "Qe::#{params[:element_type]}".constantize.active.order('label')
        # params[:element] ||= {}
        # if params[:element][:style]
        #   @questions = @questions.where(:style => params[:element][:style]).all.uniq
        # end
      end
    
      def use_existing
      end
    
      def create
      end
    
      def update
      end
    
      def destroy
      end
    
      def reorder
      end
    
      def drop
      end
    
      def duplicate
      end

      private 
      def detect_page
      end

    end
  end
end