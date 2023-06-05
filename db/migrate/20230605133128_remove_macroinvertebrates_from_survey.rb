class RemoveMacroinvertebratesFromSurvey < ActiveRecord::Migration[7.0]
  def change
    remove_column(:surveys, :macroinvertebrates)
  end
end
