# frozen_string_literal: true
class SorceryCore < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string
    change_column_null :users, :email, null: false
    change_column_null :users, :created_at, null: false
    change_column_null :users, :updated_at, null: false
    add_index :users, :email, unique: true
  end
end
