class AddExtraDataFieldsToSurvey < ActiveRecord::Migration[7.0]
  def change
    add_column :surveys, :flow_regime_choice, :string, array: true, default: []
    add_column :surveys, :water_color, :string
    add_column :surveys, :water_color_other, :string
    add_column :surveys, :turbulence, :string   
  end
end
