# Qe::QuestionSheet

module Qe
  module Admin
    class QuestionSheetsController < ::ApplicationController
      
      # GET /admin/question_sheets
      # GET /admin/question_sheets.json
      def index
        @question_sheets = Qe::QuestionSheet.all

        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @question_sheets }
        end
      end

      # GET /admin/question_sheets/1
      # GET /admin/question_sheets/1.json
      def show
        @question_sheet = Qe::QuestionSheet.find(params[:id])

        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @question_sheet }
        end
      end

      # GET /admin/question_sheets/new
      # GET /admin/question_sheets/new.json
      def new
        @question_sheet = Qe::QuestionSheet.new

        respond_to do |format|
          format.html # new.html.erb
          format.json { render json: @question_sheet }
        end
      end

      # GET /admin/question_sheets/1/edit
      def edit
        @question_sheet = Qe::QuestionSheet.find(params[:id])

        respond_to do |format|
          format.js
        end
      end

      # POST /admin/question_sheets
      # POST /admin/question_sheets.json
      def create
        @question_sheet = Qe::QuestionSheet.new(params[:question_sheet])

        respond_to do |format|
          if @question_sheet.save
            format.html { redirect_to qe.admin_question_sheet_url(@question_sheet), notice: 'Question sheet was successfully created.' }
            format.json { render json: @question_sheet, status: :created, location: @admin_question_sheet }
          else
            format.html { render action: "new" }
            format.json { render json: @question_sheet.errors, status: :unprocessable_entity }
          end
        end
      end


      # PUT /admin/question_sheets/1
      # PUT /admin/question_sheets/1.json
      def update
        @question_sheet = Qe::QuestionSheet.find(params[:id])

        respond_to do |format|
          if @question_sheet.update_attributes(params[:question_sheet])
            format.html { redirect_to qe.admin_question_sheet_url(@question_sheet), notice: 'Question sheet was successfully updated.' }
            format.json { head :no_content }
          else
            format.html { render action: "edit" }
            format.json { render json: @question_sheet.errors, status: :unprocessable_entity }
          end
        end
      end

      
      # DELETE /admin/question_sheets/1
      # DELETE /admin/question_sheets/1.json
      def destroy
        @question_sheet = Qe::QuestionSheet.find(params[:id])
        @question_sheet.destroy

        respond_to do |format|
          format.html { redirect_to qe.admin_question_sheets_url }
          format.json { head :no_content }
        end
      end

    end
  end
end