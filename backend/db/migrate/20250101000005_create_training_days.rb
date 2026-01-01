class CreateTrainingDays < ActiveRecord::Migration[7.1]
  def change
    create_table :training_days do |t|
      t.references :split, null: false, foreign_key: { to_table: :training_splits }
      t.string :day_name, null: false
      t.integer :day_order, null: false

      t.timestamps
    end

    add_index :training_days, [:split_id, :day_order], unique: true
  end
end
