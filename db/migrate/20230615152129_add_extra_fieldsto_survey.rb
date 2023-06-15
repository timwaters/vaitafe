class AddExtraFieldstoSurvey < ActiveRecord::Migration[7.0]
  def change
    add_column :surveys, :structures_other, :string
    add_column :surveys, :water_use_other, :string
    add_column :surveys, :land_use_other, :string
  end
end
