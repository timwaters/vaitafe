class SurveysController < ApplicationController

  before_action :authenticate_user!
  before_action :can_edit_survey?, :only => [:edit, :update, :destroy, :destroy_image, :destroy_animal_image]

  def index
    @surveys = Survey.order("surveyed_at desc NULLS LAST").page(params[:page])
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
    @survey.macroinvertebrates.build
    if ["chemical", "physical", "biological"].include? params[:subtype]
      @survey.subtype = params[:subtype]
    else
      redirect_to :choose 
    end
 
  end


  #save a completed survey
  def create

    @survey = Survey.new(survey_params)
    @survey.user = current_user

    if @survey.save
      redirect_to @survey
    else
      render :new, status: :unprocessable_entity
    end

  end

  def edit
  end

  def update
    if @survey.update(survey_params.except(:images))
      if survey_params[:images].present?
        survey_params[:images].each do | image |
          @survey.images.attach(image)
        end
      end
      redirect_to @survey
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
      @survey.destroy
  
      redirect_to surveys_path, status: :see_other

  end

  def destroy_image
    @image = @survey.images.find(params[:image_id])

    @image.purge
    redirect_back(fallback_location: edit_survey_path(@survey))  
  
  end

  def destroy_animal_image
    
    @image = @survey.macroinvertebrates.find(params[:animal_id]).animal_images.find(params[:image_id])
    
    unless current_user == @survey.user
      redirect_back_or_to :surveys
    end

    @image.purge
    redirect_back(fallback_location: edit_survey_path(@survey))  
  end


  private
  def survey_params
    params.require(:survey).permit(:lonlat, :river, :subtype, :comment, :surveyed_at,  {images: []}, 
      :ph, :conductivity, :phosphorus, :nitrogen, :temperature, :width, :depth, {water_use: []}, :water_use_other, :raining, {structures: []}, :structures_other, {land_use: []}, :land_use_other, {surface: []},  :flow,  :flow_regime, :riparian_description, {substrates: []}, :main_substrate , :water_color, :water_color_other, :turbulence, {flow_regime_choice: []}, {aquatic_life: []}, :aquatic_life_other, {macroinvertebrates_attributes: [:id, :name, :latin_name, :observed, :_destroy, {animal_images:[]}]} )
  end

  def can_edit_survey?
    @survey = Survey.find(params[:id])
    unless current_user == @survey.user
      redirect_back_or_to :surveys
    end
  end

end
