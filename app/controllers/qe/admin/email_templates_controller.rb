module Qe
  module Admin
    class EmailTemplatesController < ::ApplicationController
      
      module M
        extend ActiveSupport::Concern
        # included do 
        #   before_fitler :some_filter
        # end

        def index 
          @email_templates = Qe::EmailTemplate.order('name')
        
          respond_to do |format|
            format.html
          end
        end
        
        def new 
          @email_template = Qe::EmailTemplate.new
        
          respond_to do |format|
            format.html
          end
        end
        
        def edit
          @email_template = Qe::EmailTemplate.find(params[:id])
          
          respond_to do |format|
            format.html
          end
        end
        
        def create
          # TODO mass-assignment engineering
          @email_template = Qe::EmailTemplate.new(params[:email_template], :without_protection => true)
          
          respond_to do |format|
            if @email_template.save
              format.html { redirect_to admin_email_templates_path }
            else
              format.html { render :action => :new }
            end
          end
        end
        
        def update 
          # TODO mass-assignment engineering
          @email_template = Qe::EmailTemplate.find(params[:id])
          
          respond_to do |format|
            if @email_template.update_attributes(params[:email_template], :without_protection => true)
              format.html { redirect_to admin_email_templates_path }
            else
              format.html { render :action => "edit" }
            end
          end
        end
        
        def destroy
          @email_template = Qe::EmailTemplate.find(params[:id])
          @email_template.destroy

          respond_to do |format|
            format.html { redirect_to admin_email_templates_path }
          end
        end
    	end

      include Qe::Admin::BaseControllerConfigs
      include Qe::Admin::EmailTemplatesController::M
    end
  end
end