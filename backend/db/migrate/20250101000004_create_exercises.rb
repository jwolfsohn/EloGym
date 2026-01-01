class CreateExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :exercises do |t|
      t.string :name, null: false
      t.string :muscle_group
      t.string :equipment
      t.text :instructions

      t.timestamps
    end

    add_index :exercises, :name
    add_index :exercises, :muscle_group
  end
end
