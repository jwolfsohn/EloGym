class CreateFriends < ActiveRecord::Migration[7.1]
  def change
    create_table :friends do |t|
      t.references :user, null: false, foreign_key: true
      t.references :friend, null: false, foreign_key: { to_table: :users }
      t.string :status, default: "pending"

      t.timestamps
    end

    add_index :friends, [:user_id, :friend_id], unique: true
  end
end
