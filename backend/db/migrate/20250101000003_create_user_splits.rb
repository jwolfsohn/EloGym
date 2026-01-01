class CreateUserSplits < ActiveRecord::Migration[7.1]
  def change
    create_table :user_splits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :split, null: false, foreign_key: { to_table: :training_splits }

      t.timestamps
    end

    add_index :user_splits, [:user_id, :split_id], unique: true
  end
end
