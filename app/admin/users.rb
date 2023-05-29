ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :username
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :username]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :email, :password, :password_confirmation, :username

  index do
    selectable_column
    id_column
    column :email
    column :username
    column :created_at
    actions
  end

  filter :email
  filter :username
  filter :created_at


  form do |f|
    f.inputs do
      f.input :email
      f.input :username
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  sidebar "Surveys", only: :show do
 
    ul do
      #localhost:3000/admin/surveys?q[user_id_equals]=2
      li link_to("List all user's surveys", admin_surveys_path("q[user_id_equals]" => resource))
      resource.surveys.each do | survey |
        li  link_to(survey.id, admin_survey_path(survey)) 
      end
    end #ul
  end #sidebar

  
end
