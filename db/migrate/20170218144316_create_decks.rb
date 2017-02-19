class CreateDecks < ActiveRecord::Migration[5.0]
  def change
    create_table :decks do |t|
      t.string :name
      t.integer :user_id
      t.boolean :active, default: false
      t.timestamps
    end
  end
end
