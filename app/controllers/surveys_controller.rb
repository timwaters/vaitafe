class SurveysController < ApplicationController
  def index
    @surveys = Survey.all
  end


  #show a completed survey
  def show

  end


  #choose from chemical, biological, physical
  def choose

  end

  #new form with subtype
  def new
    @survey = Survey.new(surveyed_at: Time.now, river: "Vaisigano")
    if ["chemical", "physical", "biological"].include? params[:subtype]
      @survey.subtype = params[:subtype]
    else
      redirect_to :choose 
    end
 
  end


#common: comment, river, subtype, lonlat, surveyed at

 # ph phosphorus conductivity nitrogen temperature
 

  #width  depth manmade_structures flow_regime bank_description


  #riparian_description abiotic_substrate abiotic_substrate biotic_substrate
  #macroinvertebrates



  #save a completed survey
  def create

    @survey = Survey.new(title: "...", body: "...")

    if @survey.save
      redirect_to @survey
    else
      render :new, status: :unprocessable_entity
    end

  end

end
