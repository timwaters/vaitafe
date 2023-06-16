class AddAquaticLifeOtherToSurveys < ActiveRecord::Migration[7.0]
  def change
    add_column :surveys, :aquatic_life_other, :string
  end
end
