class CreateDayExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :day_exercises do |t|
      t.references :day, null: false, foreign_key: { to_table: :training_days }
      t.references :exercise, null: false, foreign_key: true

      t.timestamps
    end

    add_index :day_exercises, [:day_id, :exercise_id], unique: true
  end
end
