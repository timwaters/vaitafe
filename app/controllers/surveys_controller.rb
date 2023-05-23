class SurveysController < ApplicationController
  def index
    @surveys = Survey.all.order("surveyed_at desc NULLS LAST" )
  end


  #show a completed survey
  def show
    @survey = Survey.find(params[:id])
  end


  #choose from chemical, biological, physical
  def choose

  end

  #new form with subtype
  def new
    @survey = Survey.new(surveyed_at: Time.now, river: "Vaisigano River")
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

    @survey = Survey.new(survey_params)

    if @survey.save
      redirect_to @survey
    else
      render :new, status: :unprocessable_entity
    end

  end

  private
  def survey_params
    params.require(:survey).permit(:lonlat, :river, :subtype, :comment, :surveyed_at, 
      :ph,:conductivity, :phosphorus, :nitrogen, :temperature, :width, :depth,
      :manmade_structures,  :flow_regime, :bank_description ,:riparian_description,:abiotic_substrate, :biotic_substrate ,:macroinvertebrates  )
  end

end
