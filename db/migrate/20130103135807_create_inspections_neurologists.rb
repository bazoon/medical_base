class CreateInspectionsNeurologists < ActiveRecord::Migration
  def change
    create_table :inspections_neurologists do |t|
 	  t.integer :prof_inspection_id
      t.integer :heriditary_anamnesis	
      t.integer :min_signs
      t.integer :conscioussness
      t.timestamps
    end
  end
end
