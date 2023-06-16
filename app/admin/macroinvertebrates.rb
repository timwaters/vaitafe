ActiveAdmin.register Macroinvertebrate do
  permit_params :name, :latin_name, :observed, :survey_id, {animal_images:[]}
 
  controller do
    def update
        #this will add images to the collection
      @macroinvertebrate = Macroinvertebrate.find params[:id]
   
      if params[:macroinvertebrate][:animal_images].present?
        params[:macroinvertebrate][:animal_images].each do | image |
          @macroinvertebrate.animal_images.attach(image)
        end
      end
      params[:macroinvertebrate].reject! { |p| p["animal_images"] }

      super

    end
  end

  filter :name
  filter(:observed)
  filter(:created_at)


  index do
    selectable_column
    id_column
    column :created_at
    column :name
    column :observed
    column :survey
    column "user" do | macro |
      link_to macro.survey.user.username, admin_user_path(macro.survey.user)  if macro.survey
    end

    column :animal_images do |macro|
      macro.animal_images.each do |image|
        div do
          image_tag(image.representation(resize_to_limit: [50, 50])) 
        end
      end
      nil
    end

    actions
  end

  member_action :delete_image, method: :delete do
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge_later
    redirect_back(fallback_location: edit_admin_macroinvertebrate_path)   
  end

    
  form do | f| 

    f.inputs do
      f.input :name
      f.input :observed
    

    div class:"imagediv", style:"padding-left:1.5em;" do
      h3 "Images"
        f.object.animal_images.each do |img|
          
          li class: "" do
            figure do
              img src: rails_representation_path(img.representation(resize_to_limit: [100, 100]))
              figcaption img.filename
            end
            # delete_image_admin_survey DELETE     /admin/surveys/:id/delete_image(.:format)
            a "Delete", class: "button", href: delete_image_admin_macroinvertebrate_path(img.id), "data-method": :delete, "data-confirm": "Are you sure?"
          end
        end
        br
      f.input :animal_images, label: "Add images ", as: :file, allow_destroy: true, input_html: { multiple: true }
    end
  end

    f.actions

  end

  show do

    default_main_content

    div  do
      h3 "images"
      attributes_table do
        row :animal_images do
          div do
            macroinvertebrate.animal_images.each do |img|
              div do
                link_to(image_tag(img.representation(resize_to_limit: [100, 100])), img)
              end
            end
          end
        end
      end
    end


  end #show

  csv do
    column :id
    column :created_at
    column(:user_id) { | macro | macro.survey.user.id if macro.survey }
    column(:username){ | macro | macro.survey.user.username if macro.survey}
    column :name
    column :observed
    column(:survey) { | macro | macro.survey.id  if macro.survey}
    column :images do |macro|
      filenames = []
      macro.animal_images.each do |image|
        filenames << image.filename.to_s
      end
      filenames.join(", ")
    end
  end
  


end
