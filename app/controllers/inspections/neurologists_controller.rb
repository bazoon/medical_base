class Inspections::NeurologistsController < ApplicationController
  # GET /inspections/neurologists
  # GET /inspections/neurologists.json
  def index
    @inspections_neurologists = Inspections::Neurologist.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @inspections_neurologists }
    end
  end

  # GET /inspections/neurologists/1
  # GET /inspections/neurologists/1.json
  def show
    @inspections_neurologist = Inspections::Neurologist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @inspections_neurologist }
    end
  end

  # GET /inspections/neurologists/new
  # GET /inspections/neurologists/new.json
  def new
    @inspections_neurologist = Inspections::Neurologist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @inspections_neurologist }
    end
  end

  # GET /inspections/neurologists/1/edit
  def edit
    @inspections_neurologist = Inspections::Neurologist.find(params[:id])
  end

  # POST /inspections/neurologists
  # POST /inspections/neurologists.json
  def create
    @inspections_neurologist = Inspections::Neurologist.new(params[:inspections_neurologist])

    respond_to do |format|
      if @inspections_neurologist.save
        format.html { redirect_to @inspections_neurologist, notice: 'Neurologist was successfully created.' }
        format.json { render json: @inspections_neurologist, status: :created, location: @inspections_neurologist }
      else
        format.html { render action: "new" }
        format.json { render json: @inspections_neurologist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /inspections/neurologists/1
  # PUT /inspections/neurologists/1.json
  def update
    @inspections_neurologist = Inspections::Neurologist.find(params[:id])

    respond_to do |format|
      if @inspections_neurologist.update_attributes(params[:inspections_neurologist])
        format.html { redirect_to @inspections_neurologist, notice: 'Neurologist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @inspections_neurologist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inspections/neurologists/1
  # DELETE /inspections/neurologists/1.json
  def destroy
    @inspections_neurologist = Inspections::Neurologist.find(params[:id])
    @inspections_neurologist.destroy

    respond_to do |format|
      format.html { redirect_to inspections_neurologists_url }
      format.json { head :no_content }
    end
  end
end
