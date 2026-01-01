class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: { unique: true }
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.integer :total_points, default: 0
      t.decimal :bodyweight, precision: 5, scale: 2
      t.boolean :is_admin, default: false

      t.timestamps
    end
  end
end
