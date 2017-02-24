# frozen_string_literal: true
class AddCheckResultsColumnsToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :right_count, :integer, default: 0
    add_column :cards, :wrong_count, :integer, default: 0
  end
end
