require_dependency "qe/application_controller"

module Qe
  class JoshesController < ApplicationController
    # GET /joshes
    # GET /joshes.json
    def index
      @joshes = Josh.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @joshes }
      end
    end
  
    # GET /joshes/1
    # GET /joshes/1.json
    def show
      @josh = Josh.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @josh }
      end
    end
  
    # GET /joshes/new
    # GET /joshes/new.json
    def new
      @josh = Josh.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @josh }
      end
    end
  
    # GET /joshes/1/edit
    def edit
      @josh = Josh.find(params[:id])
    end
  
    # POST /joshes
    # POST /joshes.json
    def create
      @josh = Josh.new(params[:josh])
  
      respond_to do |format|
        if @josh.save
          format.html { redirect_to @josh, notice: 'Josh was successfully created.' }
          format.json { render json: @josh, status: :created, location: @josh }
        else
          format.html { render action: "new" }
          format.json { render json: @josh.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /joshes/1
    # PUT /joshes/1.json
    def update
      @josh = Josh.find(params[:id])
  
      respond_to do |format|
        if @josh.update_attributes(params[:josh])
          format.html { redirect_to @josh, notice: 'Josh was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @josh.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /joshes/1
    # DELETE /joshes/1.json
    def destroy
      @josh = Josh.find(params[:id])
      @josh.destroy
  
      respond_to do |format|
        format.html { redirect_to joshes_url }
        format.json { head :no_content }
      end
    end
  end
end
