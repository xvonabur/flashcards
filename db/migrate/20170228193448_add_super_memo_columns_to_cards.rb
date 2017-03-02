# frozen_string_literal: true
class AddSuperMemoColumnsToCards < ActiveRecord::Migration[5.0]
  def up
    remove_column :cards, :right_count
    remove_column :cards, :wrong_count
    add_column :cards, :factor, :float, default: 2.5
    add_column :cards, :interval, :integer, default: 0
    add_column :cards, :rep_number, :integer, default: 0
    add_column :cards, :quality, :integer, default: 0
  end

  def down
    add_column :cards, :right_count, :integer, default: 0
    add_column :cards, :wrong_count, :integer, default: 0
    remove_column :cards, :factor
    remove_column :cards, :interval
    remove_column :cards, :rep_number
    remove_column :cards, :quality
  end
end
