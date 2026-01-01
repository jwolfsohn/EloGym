class CreateCompletedExercises < ActiveRecord::Migration[7.1]
  def change
    create_table :completed_exercises do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.date :completed_at, null: false

      t.timestamps
    end

    add_index :completed_exercises, [:user_id, :exercise_id, :completed_at]
  end
end
