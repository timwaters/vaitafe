class AddExtraQuestionsToSurvey < ActiveRecord::Migration[7.0]
  def change
    add_column :surveys, :raining, :boolean 
    add_column :surveys, :water_use, :string, array: true, default: []
    add_column :surveys, :surface, :string, array: true, default: []
    add_column :surveys, :land_use, :string,  array: true, default: []
    add_column :surveys, :flow, :string
    add_column :surveys, :aquatic_life, :string, array: true, default: []
    add_column :surveys, :substrates, :string,  array: true, default: []
    add_column :surveys, :main_substrate, :string
    add_column :surveys, :structures, :string, array: true, default: []
  end
end

