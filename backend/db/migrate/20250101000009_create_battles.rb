class CreateBattles < ActiveRecord::Migration[7.1]
  def change
    create_table :battles do |t|
      t.references :challenger, null: false, foreign_key: { to_table: :users }
      t.references :opponent, null: false, foreign_key: { to_table: :users }
      t.references :winner, foreign_key: { to_table: :users }
      t.string :status, default: "pending", null: false
      t.integer :points_gained, default: 0
      t.integer :points_lost, default: 0

      t.timestamps
    end

    add_index :battles, [:challenger_id, :opponent_id]
    add_index :battles, :status
  end
end
