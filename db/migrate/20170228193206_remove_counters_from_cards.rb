class RemoveCountersFromCards < ActiveRecord::Migration[5.0]
  def up
    remove_column :cards, :right_count
    remove_column :cards, :wrong_count
  end

  def down
    add_column :cards, :right_count, :integer, default: 0
    add_column :cards, :wrong_count, :integer, default: 0
  end
end
