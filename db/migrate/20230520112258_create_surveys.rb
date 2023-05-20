class CreateSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :surveys do |t|
      t.st_point :lonlat
      t.string :river
      t.string :subtype
      t.text :comment
      t.timestamp :surveyed_at
      
      t.float :ph
      t.float :conductivity
      t.float :phosphorus
      t.float :nitrogen
      t.float :temperature
      t.float :width
      t.float :depth

      t.text :manmade_structures
      t.text :flow_regime
      t.text :bank_description
      t.text :riparian_description
      t.text :abiotic_substrate
      t.text :biotic_substrate

      t.text :macroinvertebrates


      t.timestamps
    end
  end
end
