# frozen_string_literal: true
class AddCheckResultsColumnsToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :right_results, :integer, default: 0
    add_column :cards, :wrong_results, :integer, default: 0
  end
end
