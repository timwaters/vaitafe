ActiveAdmin.register Survey do

  permit_params :lonlat, :river, :subtype, :comment, :surveyed_at, :ph, :conductivity, :phosphorus, :nitrogen, :temperature, :width, :depth, :manmade_structures, :flow_regime,  {flow_regime_choice: []}, :bank_description, :riparian_description, :abiotic_substrate, :biotic_substrate, :macroinvertebrates, :user_id,  :water_color, :water_color_other, :turbulence
  
  
  controller do
    def update
      params[:survey][:flow_regime_choice] = params[:survey][:flow_regime_choice].split(' ')
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
    column :ph
    column :conductivity
    column :phosphorus
    column :nitrogen
    column :temperature
    column :width
    column :depth
    column :manmade_structures
    column :flow_regime
    column :flow_regime_choice
    column :water_color
    column :water_color_other
    column :turbulence
    column :bank_description
    column :riparian_description
    column :abiotic_substrate
    column :biotic_substrate
    column :macroinvertebrates
  
    actions
  end

  filter :subtype
  filter :river
  filter :surveyed_at
  filter :user_id

  form do | f| 

    f.inputs do
      f.input :lonlat, as: :string
      f.input :river
      f.input :subtype
      f.input :surveyed_at
      f.input :comment
      f.input :ph
      f.input :conductivity
      f.input :phosphorus
      f.input :nitrogen
      f.input :temperature
      f.input :width
      f.input :depth
      f.input :manmade_structures
      f.input :flow_regime
      f.input :flow_regime_choice
      f.input :water_color
      f.input :water_color_other
      f.input :turbulence
      f.input :bank_description
      f.input :riparian_description
      f.input :abiotic_substrate
      f.input :biotic_substrate
      f.input :macroinvertebrates
      
      
    end

    f.actions
  end
  
end
