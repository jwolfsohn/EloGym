class AddStatsToBattles < ActiveRecord::Migration[8.1]
  def change
    add_column :battles, :challenger_bench_press, :decimal
    add_column :battles, :challenger_deadlift, :decimal
    add_column :battles, :challenger_pushups, :integer
    add_column :battles, :opponent_bench_press, :decimal
    add_column :battles, :opponent_deadlift, :decimal
    add_column :battles, :opponent_pushups, :integer
  end
end
