# frozen_string_literal: true
class AddCheckResultsColumnsToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :good_checks, :integer
    add_column :cards, :bad_checks, :integer
  end
end
