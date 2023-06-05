class CreateMacroinvertebrates < ActiveRecord::Migration[7.0]
  def change
    create_table :macroinvertebrates do |t|
      t.string :name
      t.string :latin_name
      t.string :observed

      t.timestamps
    end
    add_reference :macroinvertebrates, :survey
  end
end
