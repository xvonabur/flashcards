class AddActiveDeckIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :active_deck_id, :integer
  end
end
