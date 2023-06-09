ActiveAdmin.register Survey do
  require 'zip'
  require 'tempfile'

  permit_params :lonlat, :river, :subtype, :comment, :surveyed_at, {images:[]}, :ph, :conductivity, :phosphorus, :nitrogen, :temperature, :width, :depth, {water_use: []}, :water_use_other, :raining, {structures: []}, :structures_other, {land_use: []}, :land_use_other, :surface,  :flow, :flow_regime,  {flow_regime_choice: []},  :riparian_description, {substrates: []}, :main_substrate, :macroinvertebrates, :user_id,  :water_color, :water_color_other, :turbulence, macroinvertebrates_attributes: [:id, :name, :latin_name, :observed, :_destroy]
  
  controller do
    def update
      params[:survey][:flow_regime_choice] = params[:survey][:flow_regime_choice].split(' ')

      #this will add images to the collection
      @survey = Survey.find params[:id]
   
      if params[:survey][:images].present?
        params[:survey][:images].each do | image |
          @survey.images.attach(image)
        end
      end
      params[:survey].reject! { |p| p["images"] }

      super
    end
  end

  index do
    selectable_column
    id_column

    column :user_id do | s |
      link_to s.user.username, admin_user_path(s.user)
    end
    column :lonlat
    column :river
    column :subtype
    column :surveyed_at
    column :comment

    column :images do |survey|
      survey.images.each do |image|
        div do
          image_tag(image.representation(resize_to_limit: [50, 50])) 
        end
      end
      nil
    end

    column :ph
    column :conductivity
    column :phosphorus
    column :nitrogen
    column :temperature
    column :width
    column :depth
    column :raining
    column :water_use
    column :water_use_other
    column :structures 
    column :structures_other
    column :land_use
    column :land_use_other
    column :surface
    column :flow
    column :flow_regime
    column :flow_regime_choice
    column :water_color
    column :water_color_other
    column :turbulence
    column :riparian_description
    column :substrates
    column :main_substrate
    column :macroinvertebrates
  
    actions
  end

  filter :subtype
  filter :river
  filter :surveyed_at
  filter :user_id

  member_action :delete_image, method: :delete do
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge_later
    redirect_back(fallback_location: edit_admin_survey_path)   
  end
    
  form do | f| 

    f.inputs do
      f.input :lonlat, as: :string
      f.input :river
      f.input :subtype
      f.input :surveyed_at
      f.input :comment
      # f.input :images, as: :file, input_html: { multiple: true }
      f.input :ph
      f.input :conductivity
      f.input :phosphorus
      f.input :nitrogen
      f.input :temperature
      f.input :width
      f.input :depth
      f.input :raining
      f.input :water_use
      f.input :water_use_other
      f.input :structures 
      f.input :structures_other
      f.input :land_use
      f.input :land_use_other
      f.input :surface
      f.input :flow
 
      f.input :flow_regime
      f.input :flow_regime_choice
      f.input :water_color
      f.input :water_color_other
      f.input :turbulence
      f.input :riparian_description
      f.input :substrates
      f.input :main_substrate      
      f.inputs do
        f.has_many :macroinvertebrates,  allow_destroy: true  do |t|
          t.input :name
          t.input :observed
        end
      end

      div class:"imagediv", style:"padding-left:1.5em;" do
        h3 "Images"
          f.object.images.each do |img|
            
            li class: "" do
              figure do
                img src: rails_representation_path(img.representation(resize_to_limit: [100, 100]))
                figcaption img.filename
              end
              # delete_image_admin_survey DELETE     /admin/surveys/:id/delete_image(.:format)
              a "Delete", class: "button", href: delete_image_admin_survey_path(img.id), "data-method": :delete, "data-confirm": "Are you sure?"
            end
          end
          br
        f.input :images, label: "Add images ", as: :file, allow_destroy: true, input_html: { multiple: true }
      end
    end

    f.actions
  end

  show do

    default_main_content


    div  do
      h3 "images"
      attributes_table do
        row :images do
          div do
            survey.images.each do |img|
              div do
                link_to(image_tag(img.representation(resize_to_limit: [100, 100])), img)
              end
            end
          end
        end
      end
    end

    div do

      h3 "macroinvertebrates"
      attributes_table_for survey.macroinvertebrates do
        rows  :name, :observed
      end
    end
  end #show

  csv do
    column :id
    column(:user_id) { | s | s.user.id }
    column(:username){ | s | s.user.username}
    column :lonlat
    column :river
    column :subtype
    column :surveyed_at
    column :created_at
    column :comment
    column :ph
    column :conductivity
    column :phosphorus
    column :nitrogen
    column :temperature
    column :width
    column :depth
    column :raining
    column :water_use
    column :water_use_other
    column :structures 
    column :structures_other
    column :land_use
    column :land_use_other
    column :surface
    column :flow
    column :flow_regime
    column :flow_regime_choice
    column :water_color
    column :water_color_other
    column :turbulence
    column :riparian_description
    column :substrates
    column :main_substrate
    column(:macroinvertebrates){| s | s.macroinvertebrates.pluck( :name, :observed).flatten  if s.macroinvertebrates.size > 0 }
    column :images do |survey|
      filenames = []
      survey.images.each do |image|
        filenames << image.filename.to_s
      end
      filenames.join(", ")
    end
   
  end

  action_item :download_all_images do
    link_to 'Download All Images (zip)', download_all_images_admin_surveys_path() 
  end

  collection_action :download_all_images, method: [:get] do
    
    filename = 'survey_images.zip'
    zip_file = Tempfile.new(filename)
    begin
      Zip::OutputStream.open(zip_file.path) do |zipfile|
    
        Survey.all.each do |survey|
          if survey.images.attached?
            survey.images.each do |image|
              blob = image.blob
              next unless blob

              file_data = blob.download
              zipfile.put_next_entry(blob.filename.to_s)
              zipfile.write(file_data)
            end
          end
        end
      end

      zip_data = File.read(zip_file.path)
      send_data(zip_data, type: 'application/zip', disposition: 'attachment', filename:  filename)
    ensure 
      zip_file.close
      zip_file.unlink
    end
  end
  
  
end
