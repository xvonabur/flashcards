# frozen_string_literal: true
class AddSuperMemoColumnsToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :factor, :float, default: 2.5
    add_column :cards, :interval, :integer, default: 0
    add_column :cards, :rep_number, :integer, default: 0
    add_column :cards, :quality, :integer, default: 0
  end
end
