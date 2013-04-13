module Qe
  module Admin
    class EmailTemplatesController < Qe::Admin::AdminControllers
      
      module M
        # GET /admin/email_templates
        # GET /admin/email_templates.json
        def index 
          @email_templates = Qe::EmailTemplate.order('name')
        
          respond_to do |format|
            format.html
            format.json { render json: @email_templates }
          end
        end
        
        # GET /admin/email_templates/new
        # GET /admin/email_templates/new.json
        def new 
          @email_template = Qe::EmailTemplate.new
        
          respond_to do |format|
            format.html
            format.json { render json: @email_template }
          end
        end
        

        # GET /admin/email_templates/1/edit
        # GET /admin/email_templates/1/edit.json
        def edit
          @email_template = Qe::EmailTemplate.find(params[:id])
          
          respond_to do |format|
            format.html
            format.json { render json: @email_template }
          end
        end
        

        # POST /admin/email_templates
        def create
          @email_template = Qe::EmailTemplate.new(params[:email_template], :without_protection => true)
          
          respond_to do |format|
            if @email_template.save
              format.html { redirect_to admin_email_templates_path }
              format.json { render json: @email_template, status: :created, location: @email_template }
            else
              format.html { render :action => :new }
              format.json { render json: @email_template.errors, status: :unprocessable_entity }
            end
          end
        end
        

        # POST /admin/email_templates/1/update
        # POST /admin/email_templates/1/update.json
        def update 
          @email_template = Qe::EmailTemplate.find(params[:id])
          
          respond_to do |format|
            if @email_template.update_attributes(params[:email_template], :without_protection => true)
              format.html { redirect_to admin_email_templates_path }
              format.json { head :no_content }
            else
              format.html { render :action => "edit" }
              format.json { render json: @email_template.errors, status: :unprocessable_entity }
            end
          end
        end
        

        # DELETE /admin/email_templates/1/delete
        # DELETE /admin/email_templates/1/delete.json
        def destroy
          @email_template = Qe::EmailTemplate.find(params[:id])
          @email_template.destroy

          respond_to do |format|
            format.html { redirect_to admin_email_templates_path }
            format.json { head :no_content }
          end
        end
      end

      include M
    end
  end
end