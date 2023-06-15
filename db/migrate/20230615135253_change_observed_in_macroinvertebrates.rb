class ChangeObservedInMacroinvertebrates < ActiveRecord::Migration[7.0]
  def change
    change_column :macroinvertebrates, :observed, "integer USING NULLIF(observed, '')::int"
  end
end
